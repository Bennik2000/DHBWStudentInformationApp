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
      (String productId, PurchaseResultEnum result) =>
          _setWidgetEnabled(result == PurchaseResultEnum.Success),
    );

    _inAppPurchaseHelper
        .setPurchaseCompleteCallback(_purchaseCompletedCallback);

    await _inAppPurchaseHelper.initialize();
    await _restorePurchases();
  }

  Future<void> _restorePurchases() async {
    var didPurchaseWidget = await didBuyWidget() == PurchaseStateEnum.Purchased;
    await _setWidgetEnabled(didPurchaseWidget);
  }

  Future<PurchaseStateEnum> didBuyWidget() {
    return _inAppPurchaseHelper.didBuyId(InAppPurchaseHelper.WidgetProductId);
  }

  Future<void> buyWidget() async {
    await _inAppPurchaseHelper.buyById(InAppPurchaseHelper.WidgetProductId);
  }

  Future<void> donate() async {
    await buyWidget();
  }

  void _purchaseCompletedCallback(String productId, PurchaseResultEnum result) {
    if (purchaseCallbacks.containsKey(productId)) {
      var callback = purchaseCallbacks[productId] ?? [];

      callback.forEach((element) {
        element(productId, result);
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
