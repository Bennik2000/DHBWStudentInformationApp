import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/iap/in_app_purchase_helper.dart';
import 'package:dhbwstudentapp/native/widget/widget_helper.dart';

///
/// This class provides simple access to buy and restore in app products.
/// Note that the calls to methods of this class may take some time to return
///
class InAppPurchaseManager {
  final InAppPurchaseHelper _inAppPurchaseHelper;
  final WidgetHelper _widgetHelper;

  final Map<String, List<PurchaseCompletedCallback>> purchaseCallbacks = {};

  InAppPurchaseManager(
    PreferencesProvider _preferencesProvider,
    this._widgetHelper,
  ) : _inAppPurchaseHelper = InAppPurchaseHelper(_preferencesProvider) {
    _initialize();
  }

  void _initialize() async {
    addPurchaseCallback(
      InAppPurchaseHelper.WidgetProductId,
      (String? productId, PurchaseResultEnum result) =>
          _setWidgetEnabled(result == PurchaseResultEnum.Success),
    );

    _inAppPurchaseHelper
        .setPurchaseCompleteCallback(_purchaseCompletedCallback);

    try {
      await _inAppPurchaseHelper.initialize();
      await _restorePurchases();
    } catch (ex) {
      // TODO: [Leptopoda] disable purchases or show error message in settings when initialization was not sucessfull (i.e. no play services)
      print("Failed to initialize in app purchase!");
    }
  }

  Future<void> _restorePurchases() async {
    var didPurchaseWidget = await didBuyWidget() == PurchaseStateEnum.Purchased;
    await _setWidgetEnabled(didPurchaseWidget);
  }

  ///
  /// Determines if the widget functionality was bought
  ///
  Future<PurchaseStateEnum> didBuyWidget() {
    return _inAppPurchaseHelper.didBuyId(InAppPurchaseHelper.WidgetProductId);
  }

  ///
  /// Executes the process to purchase widget functionality
  ///
  Future<void> buyWidget() async {
    await _inAppPurchaseHelper.buyById(InAppPurchaseHelper.WidgetProductId);
  }

  Future<void> donate() async {
    await buyWidget();
  }

  // TODO: [Leptopoda] better nullseafety
  void _purchaseCompletedCallback(
      String? productId, PurchaseResultEnum result) {
    if (purchaseCallbacks.containsKey(productId)) {
      var callback = purchaseCallbacks[productId!];

      callback?.forEach((element) {
        element(productId, result);
      });
    }

    if (purchaseCallbacks.containsKey("*")) {
      var callback = purchaseCallbacks["*"];

      callback?.forEach((element) {
        element(productId, result);
      });
    }

    for (var pair in purchaseCallbacks.entries) {
      pair.value.forEach((element) {
        element(null, result);
      });
    }
  }

  ///
  /// Add a callback which gets called when a purchase was updated.
  /// Updates are registered for one specific productId. If you want to register
  /// for all product ids, pass null or "*" as productId
  ///
  void addPurchaseCallback(
    String? productId,
    PurchaseCompletedCallback callback,
  ) {
    if (productId == null) {
      productId = "*";
    }

    purchaseCallbacks[productId]?.add(callback);
  }

  ///
  /// Removes a callback which was registered using [addPurchaseCallback]
  ///
  void removePurchaseCallback(
    String? productId,
    PurchaseCompletedCallback callback,
  ) {
    if (productId == null) {
      productId = "*";
    }

    purchaseCallbacks[productId]?.remove(callback);
  }

  Future<void> _setWidgetEnabled(bool enabled) async {
    if (enabled) {
      await _widgetHelper.enableWidget();
    } else {
      await _widgetHelper.disableWidget();
    }

    await _widgetHelper.requestWidgetRefresh();
  }
}
