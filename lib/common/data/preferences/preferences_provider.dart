import 'package:dhbwstudentapp/common/data/preferences/preferences_access.dart';
import 'package:dhbwstudentapp/common/data/preferences/secure_storage_access.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';

class PreferencesProvider {
  static const String IsDarkModeKey = "IsDarkMode";
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

  final PreferencesAccess _preferencesAccess;
  final SecureStorageAccess _secureStorageAccess;

  PreferencesProvider(this._preferencesAccess, this._secureStorageAccess);

  Future<void> initializePreferencesAccess() async {
    await _preferencesAccess.initializeSharedPreferences();
  }

  Future<bool> isDarkMode() async {
    return await _preferencesAccess.get(IsDarkModeKey);
  }

  Future<void> setIsDarkMode(bool value) async {
    await _preferencesAccess.set(IsDarkModeKey, value);
  }

  Future<String> getRaplaUrl() async {
    return await _preferencesAccess.get(RaplaUrlKey) ?? "";
  }

  Future<void> setRaplaUrl(String url) async {
    await _preferencesAccess.set(RaplaUrlKey, url);
  }

  Future<bool> isFirstStart() async {
    return await _preferencesAccess.get(IsFirstStartKey) ?? true;
  }

  Future<void> setIsFirstStart(bool isFirstStart) async {
    await _preferencesAccess.set(IsFirstStartKey, isFirstStart);
  }

  Future<String> getLastUsedLanguageCode() async {
    return await _preferencesAccess.get<String>(LastUsedLanguageCode);
  }

  Future<void> setLastUsedLanguageCode(String languageCode) async {
    await _preferencesAccess.set(LastUsedLanguageCode, languageCode);
  }

  Future<bool> getNotifyAboutNextDay() async {
    return await _preferencesAccess.get<bool>(NotifyAboutNextDay) ?? true;
  }

  Future<void> setNotifyAboutNextDay(bool value) async {
    await _preferencesAccess.set(NotifyAboutNextDay, value);
  }

  Future<bool> getNotifyAboutScheduleChanges() async {
    return await _preferencesAccess.get<bool>(NotifyAboutScheduleChanges) ??
        true;
  }

  Future<void> setNotifyAboutScheduleChanges(bool value) async {
    await _preferencesAccess.set(NotifyAboutScheduleChanges, value);
  }

  Future<int> getRateInStoreLaunchCountdown() async {
    return await _preferencesAccess.get<int>(RateInStoreLaunchCountdown) ?? 10;
  }

  Future<void> setRateInStoreLaunchCountdown(int value) async {
    await _preferencesAccess.set(RateInStoreLaunchCountdown, value);
  }

  Future<bool> getDontShowRateNowDialog() async {
    return await _preferencesAccess.get<bool>(DontShowRateNowDialog) ?? false;
  }

  Future<void> setDontShowRateNowDialog(bool value) async {
    await _preferencesAccess.set(DontShowRateNowDialog, value);
  }

  Future<void> storeDualisCredentials(Credentials credentials) async {
    await _secureStorageAccess.set(DualisUsername, credentials.username ?? "");
    await _secureStorageAccess.set(DualisPassword, credentials.password ?? "");
  }

  Future<Credentials> loadDualisCredentials() async {
    var username = await _secureStorageAccess.get(DualisUsername);
    var password = await _secureStorageAccess.get(DualisPassword);
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
    await _preferencesAccess.set(DualisStoreCredentials, value ?? false);
  }

  Future<String> getLastViewedSemester() async {
    return await _preferencesAccess.get<String>(LastViewedSemester);
  }

  Future<void> setLastViewedSemester(String lastViewedSemester) async {
    await _preferencesAccess.set(LastViewedSemester, lastViewedSemester);
  }

  Future<String> getLastViewedDateEntryDatabase() async {
    return await _preferencesAccess.get<String>(LastViewedDateEntryDatabase);
  }

  Future<void> setLastViewedDateEntryDatabase(String value) async {
    await _preferencesAccess.set<String>(LastViewedDateEntryDatabase, value);
  }

  Future<String> getLastViewedDateEntryYear() async {
    return await _preferencesAccess.get<String>(LastViewedDateEntryYear);
  }

  Future<void> setLastViewedDateEntryYear(String value) async {
    await _preferencesAccess.set<String>(LastViewedDateEntryYear, value);
  }

  Future<int> getScheduleSourceType() async {
    return await _preferencesAccess.get<int>(ScheduleSourceType) ?? 0;
  }

  Future<void> setScheduleSourceType(int value) async {
    await _preferencesAccess.set<int>(ScheduleSourceType, value);
  }

  Future<String> getIcalUrl() {
    return _preferencesAccess.get(ScheduleIcalUrl);
  }

  Future<void> setIcalUrl(String url) {
    return _preferencesAccess.set(ScheduleIcalUrl, url);
  }

  Future<void> set<T>(String key, T value) async {
    return _preferencesAccess.set(key, value);
  }

  Future<T> get<T>(String key) async {
    return _preferencesAccess.get(key);
  }
}
