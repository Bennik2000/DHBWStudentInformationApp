import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/iap/in_app_purchase_helper.dart';
import 'package:dhbwstudentapp/native/widget/widget_helper.dart';

class InAppPurchaseManager {
  final InAppPurchaseHelper _inAppPurchaseHelper;
  final WidgetHelper _widgetHelper;

  InAppPurchaseManager(
    PreferencesProvider _preferencesProvider,
    this._widgetHelper,
  ) : _inAppPurchaseHelper = InAppPurchaseHelper(_preferencesProvider) {
    _initialize();
  }

  void _initialize() async {
    await _inAppPurchaseHelper.initialize();
    await _restorePurchases();
  }

  Future<void> _restorePurchases() async {
    if (await didBuyWidget()) {
      await _widgetHelper.enableWidget();
    } else {
      await _widgetHelper.disableWidget();
    }

    await _widgetHelper.requestWidgetRefresh();
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
}
