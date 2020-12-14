import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/iap/in_app_purchase_helper.dart';
import 'package:dhbwstudentapp/native/widget/widget_helper.dart';

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
      (String productId, bool isPurchased) => _setWidgetEnabled(isPurchased),
    );

    _inAppPurchaseHelper
        .setPurchaseCompleteCallback(_purchaseCompletedCallback);

    await _inAppPurchaseHelper.initialize();
    await _restorePurchases();
  }

  Future<void> _restorePurchases() async {
    await _setWidgetEnabled(await didBuyWidget());
  }

  Future<bool> didBuyWidget() {
    return _inAppPurchaseHelper.didBuyId(InAppPurchaseHelper.WidgetProductId);
  }

  Future<void> buyWidget() async {
    await _inAppPurchaseHelper.buyById(InAppPurchaseHelper.WidgetProductId);
  }

  Future<void> donate() async {
    await _inAppPurchaseHelper
        .buyById(InAppPurchaseHelper.DonateToDeveloperProductId);
  }

  void _purchaseCompletedCallback(String productId, bool isValid) {
    if (purchaseCallbacks.containsKey(productId)) {
      var callback = purchaseCallbacks[productId] ?? [];

      callback.forEach((element) {
        element(productId, isValid);
      });
    }
  }

  void addPurchaseCallback(
    String productId,
    PurchaseCompletedCallback callback,
  ) {
    if (!purchaseCallbacks.containsKey(productId)) {
      purchaseCallbacks[InAppPurchaseHelper.WidgetProductId] = [];
    }

    purchaseCallbacks[InAppPurchaseHelper.WidgetProductId].add(callback);
  }

  void removePurchaseCallback(
    String productId,
    PurchaseCompletedCallback callback,
  ) {
    purchaseCallbacks[InAppPurchaseHelper.WidgetProductId]?.remove(callback);
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
