import 'dart:async';
import 'dart:io';

import 'package:dhbwstudentapp/common/logging/analytics.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class InAppPurchaseHelper {
  static const String DonateToDeveloperProductId = "donate_to_developer";

  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;

  Future<void> initialize() async {
    await FlutterInappPurchase.instance.initConnection;

    await _completePendingPurchases();

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen(_completePurchase);

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen(_onPurchaseError);
  }

  Future<void> donateToDeveloper() async {
    await _buyById(DonateToDeveloperProductId);
  }

  Future<void> _buyById(String id) async {
    print("Attempting to buy $id");

    await analytics.logEvent(name: "purchase_$id");

    await FlutterInappPurchase.instance.getProducts([id]);
    await FlutterInappPurchase.instance.requestPurchase(id);
  }

  Future<void> _completePurchase(PurchasedItem item) async {
    print("Completing purchase: ${item.orderId}");

    if (!_isPurchased(item)) return;

    if (_isConsumable(item.productId)) {
      await FlutterInappPurchase.instance
          .consumePurchaseAndroid(item.purchaseToken);
    } else {
      await FlutterInappPurchase.instance.finishTransaction(item);
    }

    await analytics.logEvent(name: "purchaseCompleted_${item.productId}");
  }

  Future<void> _completePendingPurchases() async {
    var purchases = await FlutterInappPurchase.instance.getAvailablePurchases();

    purchases.forEach(_completePurchase);
  }

  void _onPurchaseError(PurchaseResult event) {
    print("Failed to purchase:");
    print(event.message);
    print(event.debugMessage);
  }

  bool _isConsumable(String id) {
    return id == DonateToDeveloperProductId;
  }

  bool _isPurchased(PurchasedItem item) {
    if (Platform.isAndroid) {
      return item.purchaseStateAndroid == PurchaseState.purchased;
    } else if (Platform.isIOS) {
      return item.transactionStateIOS == TransactionState.purchased;
    }

    return false;
  }

  void dispose() {
    _purchaseUpdatedSubscription?.cancel();
    _purchaseUpdatedSubscription = null;

    _purchaseErrorSubscription?.cancel();
    _purchaseErrorSubscription = null;
  }
}
