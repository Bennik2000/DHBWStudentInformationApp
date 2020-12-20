import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/common/util/platform_util.dart';
import 'package:flutter/cupertino.dart';

class RootViewModel extends BaseViewModel {
  final PreferencesProvider _preferencesProvider;

  bool _isDarkMode;
  bool get isDarkMode => _isDarkMode;

  bool _isOnboarding;
  bool get isOnboarding => _isOnboarding;

  RootViewModel(this._preferencesProvider);

  Future<void> loadFromPreferences() async {
    var darkMode = await _preferencesProvider.isDarkMode();

    _isDarkMode = darkMode;
    _isOnboarding = await _preferencesProvider.isFirstStart();

    notifyListeners("isDarkMode");
    notifyListeners("isOnboarding");
  }

  Future<void> setIsDarkMode(bool value) async {
    await _preferencesProvider.setIsDarkMode(value);
    _isDarkMode = value;
    notifyListeners("isDarkMode");
  }

  Future<void> setIsOnboarding(bool value) async {
    await _preferencesProvider.setIsFirstStart(value);
    _isOnboarding = value;
    notifyListeners("isOnboarding");
  }
}
