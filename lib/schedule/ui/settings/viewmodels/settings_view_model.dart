import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/schedule/ui/notification/next_day_information_notification.dart';

class SettingsViewModel extends BaseViewModel {
  bool _notifyAboutNextDay = false;
  bool get notifyAboutNextDay => _notifyAboutNextDay;

  bool _notifyAboutScheduleChanges = false;
  bool get notifyAboutScheduleChanges => _notifyAboutScheduleChanges;

  final PreferencesProvider _preferencesProvider;

  final NextDayInformationNotification _nextDayInformationNotification;

  SettingsViewModel(
      this._preferencesProvider, this._nextDayInformationNotification) {
    loadPreferences();
  }

  Future<void> setNotifyAboutScheduleChanges(bool value) async {
    _notifyAboutScheduleChanges = value;

    notifyListeners("notifyAboutScheduleChanges");

    await _preferencesProvider.setNotifyAboutScheduleChanges(value);
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

  Future<void> loadPreferences() async {
    _notifyAboutNextDay = await _preferencesProvider.getNotifyAboutNextDay();
    _notifyAboutScheduleChanges =
        await _preferencesProvider.getNotifyAboutScheduleChanges();

    notifyListeners("notifyAboutNextDay");
    notifyListeners("notifyAboutScheduleChanges");
  }
}
