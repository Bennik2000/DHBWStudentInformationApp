import 'package:dhbwstuttgart/common/data/preferences/preferences_access.dart';

class PreferencesProvider {
  static const String IsDarkModeKey = "IsDarkMode";
  final PreferencesAccess _preferencesAccess;

  PreferencesProvider(this._preferencesAccess);

  Future<bool> isDarkMode() async {
    return await _preferencesAccess.get(IsDarkModeKey) ?? false;
  }

  Future<void> setIsDarkMode(bool value) async {
    await _preferencesAccess.set(IsDarkModeKey, value);
  }
}
