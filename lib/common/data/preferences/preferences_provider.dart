import 'package:dhbwstudentapp/common/data/preferences/preferences_access.dart';

class PreferencesProvider {
  static const String IsDarkModeKey = "IsDarkMode";
  static const String RaplaUrlKey = "RaplaUrl";
  static const String IsFirstStartKey = "IsFirstStart";
  static const String LastUsedLanguageCode = "LastUsedLanguageCode";
  final PreferencesAccess _preferencesAccess;

  PreferencesProvider(this._preferencesAccess);

  Future<bool> isDarkMode() async {
    return await _preferencesAccess.get(IsDarkModeKey) ?? false;
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
}
