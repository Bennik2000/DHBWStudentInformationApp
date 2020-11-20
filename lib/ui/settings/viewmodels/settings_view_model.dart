import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/schedule/ui/notification/next_day_information_notification.dart';

///
/// The view model for the settings page.
///
class SettingsViewModel extends BaseViewModel {
  final PreferencesProvider _preferencesProvider;
  final NextDayInformationNotification _nextDayInformationNotification;

  bool _notifyAboutNextDay = false;

  bool get notifyAboutNextDay => _notifyAboutNextDay;

  bool _notifyAboutScheduleChanges = false;

  bool get notifyAboutScheduleChanges => _notifyAboutScheduleChanges;

  bool _prettifySchedule = false;

  bool get prettifySchedule => _prettifySchedule;

  SettingsViewModel(
    this._preferencesProvider,
    this._nextDayInformationNotification,
  ) {
    _loadPreferences();
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

    notifyListeners("notifyAboutNextDay");
    notifyListeners("notifyAboutScheduleChanges");
    notifyListeners("prettifySchedule");
  }
}
