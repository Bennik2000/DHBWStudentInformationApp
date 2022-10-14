import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/iap/in_app_purchase_helper.dart';
import 'package:dhbwstudentapp/common/iap/in_app_purchase_manager.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/native/widget/widget_helper.dart';
import 'package:dhbwstudentapp/schedule/ui/notification/next_day_information_notification.dart';
import 'package:kiwi/kiwi.dart';

import '../../../common/util/cancellation_token.dart';
import '../../../schedule/business/schedule_provider.dart';

///
/// The view model for the settings page.
///
class SettingsViewModel extends BaseViewModel {
  final PreferencesProvider _preferencesProvider;
  final WidgetHelper _widgetHelper;
  final NextDayInformationNotification _nextDayInformationNotification;
  final InAppPurchaseManager _inAppPurchaseManager;

  bool _notifyAboutNextDay = false;

  bool get notifyAboutNextDay => _notifyAboutNextDay;

  bool _notifyAboutScheduleChanges = false;

  bool get notifyAboutScheduleChanges => _notifyAboutScheduleChanges;

  bool _prettifySchedule = false;

  bool get prettifySchedule => _prettifySchedule;

  bool _isCalendarSyncEnabled = false;

  bool get isCalendarSyncEnabled => _isCalendarSyncEnabled;

  PurchaseStateEnum? _widgetPurchaseState;

  PurchaseStateEnum? get widgetPurchaseState => _widgetPurchaseState;

  bool? _areWidgetsSupported = false;

  bool? get areWidgetsSupported => _areWidgetsSupported;

  SettingsViewModel(
      this._preferencesProvider,
      this._nextDayInformationNotification,
      this._widgetHelper,
      this._inAppPurchaseManager,) {
    _loadPreferences();

    _inAppPurchaseManager.addPurchaseCallback(
      InAppPurchaseHelper.WidgetProductId,
      _widgetPurchaseCallback,
    );
  }

  Future<void> setIsCalendarSyncEnabled(bool value) async {
    _isCalendarSyncEnabled = value;

    notifyListeners("isCalendarSyncEnabled");

    await _preferencesProvider.setIsCalendarSyncEnabled(value);

    var scheduleProvider = KiwiContainer().resolve<ScheduleProvider>();
    scheduleProvider.getUpdatedSchedule(
      DateTime.now(),
      DateTime.now().add(Duration(days: 30)),
      CancellationToken(),
    );
  }

  void _widgetPurchaseCallback(String? id, PurchaseResultEnum result) {
    if (result == PurchaseResultEnum.Success) {
      _widgetPurchaseState = PurchaseStateEnum.Purchased;
    }
    notifyListeners("didPurchaseWidget");
  }

  Future<void> setNotifyAboutScheduleChanges(bool value) async {
    _notifyAboutScheduleChanges = value;

    notifyListeners("notifyAboutScheduleChanges");

    await _preferencesProvider.setNotifyAboutScheduleChanges(value);
  }

  Future<void> setPrettifySchedule(bool value) async {
    _prettifySchedule = value;

    notifyListeners("prettifySchedule");

    await _preferencesProvider.setPrettifySchedule(value);
  }

  Future<void> setNotifyAboutNextDay(bool value) async {
    _notifyAboutNextDay = value;

    notifyListeners("notifyAboutNextDay");

    await _preferencesProvider.setNotifyAboutNextDay(value);

    if (value)
      await _nextDayInformationNotification.schedule();
    else
      await _nextDayInformationNotification.cancel();
  }

  Future<void> _loadPreferences() async {
    _notifyAboutNextDay = await _preferencesProvider.getNotifyAboutNextDay();
    _notifyAboutScheduleChanges =
        await _preferencesProvider.getNotifyAboutScheduleChanges();

    _prettifySchedule = await _preferencesProvider.getPrettifySchedule();
    _areWidgetsSupported = await _widgetHelper.areWidgetsSupported();

    notifyListeners("notifyAboutNextDay");
    notifyListeners("notifyAboutScheduleChanges");
    notifyListeners("prettifySchedule");
    notifyListeners("areWidgetsSupported");

    // This call may take some time. Do it at the end when the rest is already
    // loaded
    _widgetPurchaseState = await _inAppPurchaseManager.didBuyWidget();
    notifyListeners("didPurchaseWidget");
  }

  Future<void> purchaseWidgets() async {
    if (_widgetPurchaseState != PurchaseStateEnum.Purchased) {
      await _inAppPurchaseManager.buyWidget();
    }
  }

  Future<void> donate() async {
    await _inAppPurchaseManager.donate();
  }

  void dispose() {
    super.dispose();

    _inAppPurchaseManager.removePurchaseCallback(
      InAppPurchaseHelper.WidgetProductId,
      _widgetPurchaseCallback,
    );
  }
}
