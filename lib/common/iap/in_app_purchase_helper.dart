import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseHelper {
  static const String DonateToDeveloperProductId = "donate_to_developer";

  StreamSubscription<List<PurchaseDetails>> _subscription;

  Future<void> donateToDeveloper() async {
    await _buyById(DonateToDeveloperProductId);
  }

  void initialize() {
    InAppPurchaseConnection.enablePendingPurchases();

    _subscription = InAppPurchaseConnection.instance.purchaseUpdatedStream
        .listen(_listenToPurchaseUpdated, onDone: () {
      _subscription.cancel();
    });
  }

  Future<void> _buyById(String id) async {
    if (!await InAppPurchaseConnection.instance.isAvailable()) return;

    var product = await _getProductDetails(id);

    if (product == null) return;

    print("Attempting to buy ${product.title} (${product.description})");

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: product,
    );

    if (_isConsumable(id)) {
      await InAppPurchaseConnection.instance.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true,
      );
    } else {
      await InAppPurchaseConnection.instance.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
    }
  }

  Future<bool> _didBuyNonConsumable(String id) async {
    var purchases = await InAppPurchaseConnection.instance.queryPastPurchases();

    var purchase =
        purchases.pastPurchases?.where((element) => element.productID == id);

    return purchase.isNotEmpty;
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
      if (_isConsumable(p.productID)) continue;

      await InAppPurchaseConnection.instance.completePurchase(p);
    }
  }

  bool _isConsumable(String id) {
    return id == DonateToDeveloperProductId;
  }
}
