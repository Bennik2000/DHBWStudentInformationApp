import 'dart:async';
import 'dart:io';

import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/logging/analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

enum PurchaseStateEnum {
  Purchased,
  NotPurchased,
  Unknown,
}

enum PurchaseResultEnum {
  Success,
  UserCancelled,
  Error,
  Pending,
}

typedef PurchaseCompletedCallback = Function(
  String? productId,
  PurchaseResultEnum result,
);

///
/// InAppPurchaseHelper class abstracts the native purchase functionality.
/// It provides methods to purchase products and consumables
///
class InAppPurchaseHelper {
  static const String WidgetProductId = "app_widget";

  final PreferencesProvider _preferencesProvider;

  StreamSubscription? _purchaseUpdatedSubscription;
  StreamSubscription? _purchaseErrorSubscription;

  PurchaseCompletedCallback? _purchaseCallback;

  InAppPurchaseHelper(this._preferencesProvider);

  ///
  /// Initializes the in app purchase library. This function has to be called
  /// at the start of the app.
  ///
  Future<void> initialize() async {
    print("Initializing in app purchases...");

    await FlutterInappPurchase.instance.initialize();

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
  Future<PurchaseResultEnum> buyById(String id) async {
    print("Attempting to buy $id");

    await analytics.logEvent(name: "purchase_$id");

    await _preferencesProvider.setHasPurchasedSomething(true);

    try {
      await FlutterInappPurchase.instance.getProducts([id]);
      await FlutterInappPurchase.instance.requestPurchase(id);

      return PurchaseResultEnum.Success;
    } on PlatformException catch (_) {
      if (_purchaseCallback != null) {
        _purchaseCallback!(id, PurchaseResultEnum.Error);
      }

      return PurchaseResultEnum.Error;
    }
  }

  ///
  /// Checks if the user bought a product already.
  /// When the app is reinstalled this method returns false even if a product
  /// was bought previousley. After the [buyById] method is called it returns
  /// true if a product was bought previousley.
  ///
  Future<PurchaseStateEnum> didBuyId(String id) async {
    if (!await _preferencesProvider.getHasPurchasedSomething()) {
      return PurchaseStateEnum.NotPurchased;
    }

    try {
      var allPurchases =
          await FlutterInappPurchase.instance.getAvailablePurchases();

      var productIdPurchases =
          allPurchases?.where((element) => element.productId == id);

      if (productIdPurchases?.isNotEmpty ?? false) {
        return productIdPurchases!.any((element) => _isPurchased(element))
            ? PurchaseStateEnum.Purchased
            : PurchaseStateEnum.NotPurchased;
      }

      return PurchaseStateEnum.NotPurchased;
    } on Exception catch (_) {
      return PurchaseStateEnum.Unknown;
    }
  }

  ///
  /// Sets the callback function that gets executed when a purchase succeeded
  /// or failed
  ///
  void setPurchaseCompleteCallback(PurchaseCompletedCallback callback) {
    _purchaseCallback = callback;
  }

  Future<void> _completePurchase(PurchasedItem? item) async {
    if (item == null) return;

    var purchaseResult = _purchaseResultFromItem(item);

    _purchaseCallback?.call(item.productId, purchaseResult);

    if (purchaseResult == PurchaseResultEnum.Pending) return;
    if (await _hasFinishedTransaction(item)) return;

    print("Completing purchase: ${item.transactionId} (${item.productId})");

    try {
      await FlutterInappPurchase.instance.finishTransaction(
        item,
        isConsumable: _isConsumable(item.productId),
      );

      await _preferencesProvider.set(
        "purchase_${item.productId}_finished",
        true,
      );

      await analytics.logEvent(name: "purchaseCompleted_${item.productId}");
    } catch (_) {
      print(_);
    }
  }

  PurchaseResultEnum _purchaseResultFromItem(PurchasedItem item) {
    if (Platform.isAndroid) {
      switch (item.purchaseStateAndroid) {
        case PurchaseState.pending:
          return PurchaseResultEnum.Pending;

        case PurchaseState.purchased:
          return PurchaseResultEnum.Success;
        case PurchaseState.unspecified:
        default:
          return PurchaseResultEnum.Error;
      }
    } else if (Platform.isIOS) {
      switch (item.transactionStateIOS) {
        case TransactionState.purchasing:
          return PurchaseResultEnum.Pending;
        case TransactionState.purchased:
          return PurchaseResultEnum.Success;
        case TransactionState.restored:
          return PurchaseResultEnum.Success;
        case TransactionState.deferred:
          return PurchaseResultEnum.Pending;
        case TransactionState.failed:
        default:
          return PurchaseResultEnum.Error;
      }
    }
    return PurchaseResultEnum.Error;
  }

  Future<bool> _hasFinishedTransaction(PurchasedItem item) async {
    if (item.isAcknowledgedAndroid ?? false) return true;

    return await _preferencesProvider
            .get<bool>("purchase_${item.productId}_finished") ??
        false;
  }

  Future<void> _completePendingPurchases() async {
    print("Completing pending purchases");

    if (!await _preferencesProvider.getHasPurchasedSomething()) {
      print(
          "Abort complete pending purchases, the user did not buy something in the past",);
      return;
    }

    List<PurchasedItem>? purchasedItems;

    if (Platform.isAndroid) {
      purchasedItems =
          await FlutterInappPurchase.instance.getAvailablePurchases();
    } else if (Platform.isIOS) {
      purchasedItems =
          await FlutterInappPurchase.instance.getPendingTransactionsIOS();
    }

    if (purchasedItems != null) {
      print("Found ${purchasedItems.length} pending purchases");

      purchasedItems.forEach(_completePurchase);
    }
  }

  void _onPurchaseError(PurchaseResult? event) {
    print("Failed to purchase:");
    print(event?.message);
    print(event?.debugMessage);

    _purchaseCallback?.call(null, PurchaseResultEnum.Error);
  }

  // TODO: [Leptopdoa] remove this¿?
  bool _isConsumable(String? id) {
    return false;
  }

  bool _isPurchased(PurchasedItem item) {
    if (Platform.isAndroid) {
      return item.purchaseStateAndroid == PurchaseState.purchased;
    } else if (Platform.isIOS) {
      return item.transactionStateIOS == TransactionState.purchased ||
          item.transactionStateIOS == TransactionState.restored;
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
