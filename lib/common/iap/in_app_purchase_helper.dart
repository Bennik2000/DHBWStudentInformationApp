import 'dart:async';
import 'dart:io';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class InAppPurchaseHelper {
  static const String DonateToDeveloperProductId = "donate_to_developer";

  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;

  Future<void> initialize() async {
    print("Initializing in app purchases...");

    await FlutterInappPurchase.instance.initConnection;

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen(_completePurchase);

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen(_onPurchaseError);

    print("In app purchases initialized");

    _completePendingPurchases();
  }

  Future<void> donateToDeveloper() async {
    await _buyById(DonateToDeveloperProductId);
  }

  Future<void> _buyById(String id) async {
    print("Attempting to buy $id");

    await FlutterInappPurchase.instance.getProducts([id]);
    await FlutterInappPurchase.instance.requestPurchase(id);
  }

  Future<void> _completePurchase(PurchasedItem item) async {
    print("Completing purchase: ${item.orderId} (${item.productId})");

    if (!_isPurchased(item)) return;

    await FlutterInappPurchase.instance.finishTransaction(
      item,
      isConsumable: _isConsumable(item.productId),
    );
  }

  Future<void> _completePendingPurchases() async {
    print("Completing pending purchases");

    List<PurchasedItem> purchasedItems = [];

    if (Platform.isAndroid) {
      purchasedItems =
          await FlutterInappPurchase.instance.getAvailablePurchases();
    } else if (Platform.isIOS) {
      purchasedItems =
          await FlutterInappPurchase.instance.getPendingTransactionsIOS();
    }

    print("Found ${purchasedItems.length} pending purchases");

    purchasedItems.forEach(_completePurchase);
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
