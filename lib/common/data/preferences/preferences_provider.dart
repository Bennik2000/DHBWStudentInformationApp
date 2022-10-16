import 'package:device_calendar/device_calendar.dart';
import 'package:dhbwstudentapp/common/application_constants.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_access.dart';
import 'package:dhbwstudentapp/common/data/preferences/secure_storage_access.dart';
import 'package:dhbwstudentapp/date_management/data/calendar_access.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';
import 'package:flutter/material.dart';

class PreferencesProvider {
  static const String AppThemeKey = "AppTheme";
  static const String RaplaUrlKey = "RaplaUrl";
  static const String IsFirstStartKey = "IsFirstStart";
  static const String LastUsedLanguageCode = "LastUsedLanguageCode";
  static const String NotifyAboutNextDay = "NotifyAboutNextDay";
  static const String NotifyAboutScheduleChanges = "NotifyAboutScheduleChanges";
  static const String RateInStoreLaunchCountdown = "RateInStoreLaunchCountdown";
  static const String DontShowRateNowDialog = "RateNeverButtonPressed";
  static const String DualisStoreCredentials = "StoreDualisCredentials";
  static const String DualisUsername = "DualisUsername";
  static const String DualisPassword = "DualisPassword";
  static const String LastViewedSemester = "LastViewedSemester";
  static const String LastViewedDateEntryDatabase =
      "LastViewedDateEntryDatabase";
  static const String LastViewedDateEntryYear = "LastViewedDateEntryYear";
  static const String ScheduleSourceType = "ScheduleSourceType";
  static const String ScheduleIcalUrl = "ScheduleIcalUrl";
  static const String MannheimScheduleId = "MannheimScheduleId";
  static const String PrettifySchedule = "PrettifySchedule";
  static const String DidShowWidgetHelpDialog = "DidShowWidgetHelpDialog";
  static const String SynchronizeScheduleWithCalendar =
      "SynchronizeScheduleWithCalendar";

  final PreferencesAccess _preferencesAccess;
  final SecureStorageAccess _secureStorageAccess;

  const PreferencesProvider(this._preferencesAccess, this._secureStorageAccess);

  Future<ThemeMode> appTheme() async {
    final theme = await _preferencesAccess.get<String>(AppThemeKey);
    final themeName = theme?.toLowerCase();

    return ThemeMode.values.firstWhere(
      (element) => element.name == themeName,
      orElse: () {
        return ThemeMode.system;
      },
    );
  }

  Future<void> setAppTheme(ThemeMode value) async {
    await _preferencesAccess.set<String>(AppThemeKey, value.name);
  }

  Future<void> setIsCalendarSyncEnabled(bool value) async {
    await _preferencesAccess.set<bool>('isCalendarSyncEnabled', value);
  }

  Future<bool> isCalendarSyncEnabled() async {
    return await _preferencesAccess.get<bool>('isCalendarSyncEnabled') ?? false;
  }

  Future<void> setSelectedCalendar(Calendar? selectedCalendar) async {
    final selectedCalendarId = selectedCalendar?.id ?? "";
    await _preferencesAccess.set<String>(
      'SelectedCalendarId',
      selectedCalendarId,
    );
  }

  Future<Calendar?> getSelectedCalendar() async {
    Calendar? selectedCalendar;
    final String? selectedCalendarId =
        await _preferencesAccess.get<String>('SelectedCalendarId');
    final List<Calendar>? availableCalendars =
        await CalendarAccess().queryWriteableCalendars();
    if (selectedCalendarId == null || availableCalendars == null) return null;
    for (final cal in availableCalendars) {
      {
        if (cal.id == selectedCalendarId) {
          selectedCalendar = cal;
        }
      }
    }
    return selectedCalendar;
  }

  Future<String> getRaplaUrl() async {
    return await _preferencesAccess.get<String>(RaplaUrlKey) ?? "";
  }

  Future<void> setRaplaUrl(String url) async {
    await _preferencesAccess.set<String>(RaplaUrlKey, url);
  }

  Future<bool> isFirstStart() async {
    return await _preferencesAccess.get<bool>(IsFirstStartKey) ?? true;
  }

  Future<void> setIsFirstStart(bool isFirstStart) async {
    await _preferencesAccess.set<bool>(IsFirstStartKey, isFirstStart);
  }

  Future<String?> getLastUsedLanguageCode() async {
    return _preferencesAccess.get<String>(LastUsedLanguageCode);
  }

  Future<void> setLastUsedLanguageCode(String languageCode) async {
    await _preferencesAccess.set<String>(LastUsedLanguageCode, languageCode);
  }

  Future<bool> getNotifyAboutNextDay() async {
    return await _preferencesAccess.get<bool>(NotifyAboutNextDay) ?? true;
  }

  Future<void> setNotifyAboutNextDay(bool value) async {
    await _preferencesAccess.set<bool>(NotifyAboutNextDay, value);
  }

  Future<bool> getNotifyAboutScheduleChanges() async {
    return await _preferencesAccess.get<bool>(NotifyAboutScheduleChanges) ??
        true;
  }

  Future<void> setNotifyAboutScheduleChanges(bool value) async {
    await _preferencesAccess.set<bool>(NotifyAboutScheduleChanges, value);
  }

  Future<bool> getDontShowRateNowDialog() async {
    return await _preferencesAccess.get<bool>(DontShowRateNowDialog) ?? false;
  }

  Future<void> setDontShowRateNowDialog(bool value) async {
    await _preferencesAccess.set<bool>(DontShowRateNowDialog, value);
  }

  Future<void> storeDualisCredentials(Credentials credentials) async {
    await _secureStorageAccess.set(DualisUsername, credentials.username);
    await _secureStorageAccess.set(DualisPassword, credentials.password);
  }

  Future<Credentials?> loadDualisCredentials() async {
    final username = await _secureStorageAccess.get(DualisUsername);
    final password = await _secureStorageAccess.get(DualisPassword);

    if (username == null ||
        password == null ||
        username.isEmpty ||
        password.isEmpty) return null;
    return Credentials(username, password);
  }

  Future<void> clearDualisCredentials() async {
    await _secureStorageAccess.set(DualisUsername, "");
    await _secureStorageAccess.set(DualisPassword, "");
  }

  Future<bool> getStoreDualisCredentials() async {
    return await _preferencesAccess.get<bool>(DualisStoreCredentials) ?? false;
  }

  Future<void> setStoreDualisCredentials(bool value) async {
    await _preferencesAccess.set<bool>(DualisStoreCredentials, value);
  }

  Future<String?> getLastViewedSemester() async {
    return _preferencesAccess.get<String>(LastViewedSemester);
  }

  Future<void> setLastViewedSemester(String? lastViewedSemester) async {
    if (lastViewedSemester == null) return;
    await _preferencesAccess.set<String>(
      LastViewedSemester,
      lastViewedSemester,
    );
  }

  Future<String?> getLastViewedDateEntryDatabase() async {
    return _preferencesAccess.get<String>(LastViewedDateEntryDatabase);
  }

  Future<void> setLastViewedDateEntryDatabase(String? value) async {
    await _preferencesAccess.set<String>(
      LastViewedDateEntryDatabase,
      value ?? "",
    );
  }

  Future<String?> getLastViewedDateEntryYear() async {
    return _preferencesAccess.get<String>(LastViewedDateEntryYear);
  }

  Future<void> setLastViewedDateEntryYear(String? value) async {
    if (value == null) return;
    await _preferencesAccess.set<String>(LastViewedDateEntryYear, value);
  }

  Future<int> getScheduleSourceType() async {
    return await _preferencesAccess.get<int>(ScheduleSourceType) ?? 0;
  }

  Future<void> setScheduleSourceType(int value) async {
    await _preferencesAccess.set<int>(ScheduleSourceType, value);
  }

  Future<String?> getIcalUrl() {
    return _preferencesAccess.get<String>(ScheduleIcalUrl);
  }

  Future<void> setIcalUrl(String url) {
    return _preferencesAccess.set<String>(ScheduleIcalUrl, url);
  }

  Future<String?> getMannheimScheduleId() {
    return _preferencesAccess.get<String>(MannheimScheduleId);
  }

  Future<void> setMannheimScheduleId(String url) {
    return _preferencesAccess.set<String>(MannheimScheduleId, url);
  }

  Future<bool> getPrettifySchedule() async {
    return await _preferencesAccess.get<bool>(PrettifySchedule) ?? true;
  }

  Future<void> setPrettifySchedule(bool value) {
    return _preferencesAccess.set<bool>(PrettifySchedule, value);
  }

  Future<bool> getSynchronizeScheduleWithCalendar() async {
    return await _preferencesAccess
            .get<bool>(SynchronizeScheduleWithCalendar) ??
        true;
  }

  Future<void> setSynchronizeScheduleWithCalendar(bool value) {
    return _preferencesAccess.set<bool>(SynchronizeScheduleWithCalendar, value);
  }

  Future<bool> getDidShowWidgetHelpDialog() async {
    return await _preferencesAccess.get<bool>(DidShowWidgetHelpDialog) ?? false;
  }

  Future<void> setDidShowWidgetHelpDialog(bool value) {
    return _preferencesAccess.set<bool>(DidShowWidgetHelpDialog, value);
  }

  Future<void> set<T>(String key, T value) async {
    if (value == null) return;
    return _preferencesAccess.set(key, value);
  }

  Future<T?> get<T>(String key) async {
    return _preferencesAccess.get<T?>(key);
  }

  Future<int> getAppLaunchCounter() async {
    return await _preferencesAccess.get<int>("AppLaunchCount") ?? 0;
  }

  Future<void> setAppLaunchCounter(int value) async {
    return _preferencesAccess.set<int>("AppLaunchCount", value);
  }

  Future<int> getNextRateInStoreLaunchCount() async {
    return await _preferencesAccess.get<int>("NextRateInStoreLaunchCount") ??
        RateInStoreLaunchAfter;
  }

  Future<void> setNextRateInStoreLaunchCount(int value) async {
    return _preferencesAccess.set<int>("NextRateInStoreLaunchCount", value);
  }

  Future<bool> getDidShowDonateDialog() async {
    return await _preferencesAccess.get<bool>("DidShowDonateDialog") ?? false;
  }

  Future<void> setDidShowDonateDialog(bool value) {
    return _preferencesAccess.set<bool>("DidShowDonateDialog", value);
  }

  Future<bool> getHasPurchasedSomething() async {
    return await _preferencesAccess.get<bool>("HasPurchasedSomething") ?? false;
  }

  Future<void> setHasPurchasedSomething(bool value) {
    return _preferencesAccess.set<bool>("HasPurchasedSomething", value);
  }
}
