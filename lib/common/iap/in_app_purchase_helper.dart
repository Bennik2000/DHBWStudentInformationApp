import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseHelper {
  StreamSubscription<List<PurchaseDetails>> _subscription;

  Function(String s) messageCallback;

  void initialize() {
    InAppPurchaseConnection.enablePendingPurchases();

    _subscription = InAppPurchaseConnection.instance.purchaseUpdatedStream
        .listen(_listenToPurchaseUpdated, onDone: () {
      _subscription.cancel();
    });
  }

  Future<void> donateToDeveloper() async {
    await _buyConsumableById('donate_to_developer');
  }

  Future<void> _buyConsumableById(String id) async {
    if (!await InAppPurchaseConnection.instance.isAvailable()) return;

    var product = await _getProductDetails(id);

    print("Attempting to buy ${product.title} (${product.description})");

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: product,
    );

    await InAppPurchaseConnection.instance.buyConsumable(
      purchaseParam: purchaseParam,
    );
  }

  Future<ProductDetails> _getProductDetails(String id) async {
    final ProductDetailsResponse response = await InAppPurchaseConnection
        .instance
        .queryProductDetails([id].toSet());

    if (response.notFoundIDs.isNotEmpty ||
        response.productDetails.length != 1) {
      print("Did not find product with id $id");
      return null;
    }

    return response.productDetails.first;
  }

  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (var p in purchaseDetailsList) {
      if (p.status == PurchaseStatus.pending) continue;
      if (!p.pendingCompletePurchase) continue;

      var result = await InAppPurchaseConnection.instance.completePurchase(p);

      print(
          "completePurchase() result: ${result.responseCode} (${result.debugMessage})");

      if (result.responseCode != BillingResponse.ok) {}
    }
  }
}
