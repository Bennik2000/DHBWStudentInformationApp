import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseHelper {
  StreamSubscription<List<PurchaseDetails>> _subscription;

  Function(String s) messageCallback;

  void initialize() {
    InAppPurchaseConnection.enablePendingPurchases();

    Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;

    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
  }

  Future<String> donateToDeveloper() async {
    var s = "Querying last purchases...";
    var list = await InAppPurchaseConnection.instance.queryPastPurchases();

    if (list.error != null) {
      s += "Error message: ${list.error.message}\n";
      s += "Code: ${list.error.code}\n";
      s += "Details: ${list.error.details}\n";
    } else {
      if (list.pastPurchases.isEmpty) {
        s += " -> nothing bought so far\n";
      } else {
        for (var element in list.pastPurchases) {
          s += "Product id: ${element.productID}\n";
          s += "Purchase id: ${element.purchaseID}\n";
          s += "--------------------\n";
        }
      }
    }

    s += "\n" + (await _buyConsumableById('donate_to_developer'));

    print(s);

    messageCallback(s);

    return s;
  }

  Future<String> _buyConsumableById(String id) async {
    final ProductDetailsResponse response = await InAppPurchaseConnection
        .instance
        .queryProductDetails([id].toSet());

    if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
      return "Did not find product with id $id";
    }

    List<ProductDetails> productDetails = response.productDetails;

    var s =
        "Buying ${productDetails[0].title} (${productDetails[0].description})";

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails[0],
    );

    await InAppPurchaseConnection.instance.buyConsumable(
      purchaseParam: purchaseParam,
    );

    return s;
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    String s = "";
    for (var p in purchaseDetailsList) {
      s += "------------------\n";
      s += "productId: ${p.productID}\n";
      s += "purchaseId: ${p.purchaseID}\n";
      s += "transactionDate: ${p.transactionDate}\n";
      s += "status: ${p.status}\n";
      s += "pendingCompletePurchase: ${p.pendingCompletePurchase}\n";

      if (p.pendingCompletePurchase) {
        var result = await InAppPurchaseConnection.instance.completePurchase(p);

        s +=
            "completePurchase result: ${result.responseCode} (${result.debugMessage})\n";

        if (result.responseCode != BillingResponse.ok) {}
      }
      s += "------------------\n";
    }

    print(s);

    messageCallback(s);
  }
}
