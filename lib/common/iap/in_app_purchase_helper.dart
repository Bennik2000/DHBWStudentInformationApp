import 'dart:async';
import 'dart:io';

import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/logging/analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

typedef PurchaseCompletedCallback = Function(
  String productId,
  bool isPurchased,
);

///
/// InAppPurchaseHelper class abstracts the native purchase functionality.
/// It provides methods to purchase products and consumables
///
class InAppPurchaseHelper {
  static const String WidgetProductId = "app_widget";

  final PreferencesProvider _preferencesProvider;

  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;

  PurchaseCompletedCallback _purchaseCallback;

  InAppPurchaseHelper(this._preferencesProvider);

  ///
  /// Initializes the in app purchase library. This function has to be called
  /// at the start of the app.
  ///
  Future<void> initialize() async {
    print("Initializing in app purchases...");

    await FlutterInappPurchase.instance.initConnection;

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen(_completePurchase);

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen(_onPurchaseError);

    print("In app purchases initialized");

    await _completePendingPurchases();
  }

  ///
  /// Tries to buy a product by its id
  ///
  Future<void> buyById(String id) async {
    print("Attempting to buy $id");

    await analytics.logEvent(name: "purchase_$id");

    await _preferencesProvider.setHasPurchasedSomething(true);

    try {
      await FlutterInappPurchase.instance.getProducts([id]);
      await FlutterInappPurchase.instance.requestPurchase(id);
    } on PlatformException catch (_) {
      if (_purchaseCallback != null) {
        _purchaseCallback(id, false);
      }
    }
  }

  ///
  /// Checks if the user bought a product already.
  /// When the app is reinstalled this method returns false even if a product
  /// was bought previousley. After the [buyById] method is called it returns
  /// true if a product was bought previousley.
  ///
  Future<bool> didBuyId(String id) async {
    if (!await _preferencesProvider.getHasPurchasedSomething()) {
      return false;
    }

    var allPurchases =
        await FlutterInappPurchase.instance.getAvailablePurchases();

    var productIdPurchases =
        allPurchases.where((element) => element.productId == id);

    if (productIdPurchases.isEmpty) {
      return false;
    }

    return productIdPurchases.any((element) => _isPurchased(element));
  }

  ///
  /// Sets the callback function that gets executed when a purchase succeeded
  /// or failed
  ///
  void setPurchaseCompleteCallback(PurchaseCompletedCallback callback) {
    _purchaseCallback = callback;
  }

  Future<void> _completePurchase(PurchasedItem item) async {
    print("Completing purchase: ${item.orderId} (${item.productId})");

    var isPurchased = _isPurchased(item);

    if (_purchaseCallback != null) {
      _purchaseCallback(item.productId, isPurchased);
    }

    if (!isPurchased) return;

    await FlutterInappPurchase.instance.finishTransaction(
      item,
      isConsumable: _isConsumable(item.productId),
    );

    await analytics.logEvent(name: "purchaseCompleted_${item.productId}");
  }

  Future<void> _completePendingPurchases() async {
    print("Completing pending purchases");

    if (!await _preferencesProvider.getHasPurchasedSomething()) {
      print(
          "Abort complete pending purchases, the user did not buy something in the past");
      return;
    }

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
    return false;
  }

  bool _isPurchased(PurchasedItem item) {
    if (Platform.isAndroid) {
      return item.purchaseStateAndroid == PurchaseState.purchased;
    } else if (Platform.isIOS) {
      return item.transactionStateIOS == TransactionState.purchased;
    }

    return false;
  }

  ///
  /// Disposes the subscriptions. Call this at the end of the object lifetime.
  ///
  void dispose() {
    _purchaseUpdatedSubscription?.cancel();
    _purchaseUpdatedSubscription = null;

    _purchaseErrorSubscription?.cancel();
    _purchaseErrorSubscription = null;
  }
}
