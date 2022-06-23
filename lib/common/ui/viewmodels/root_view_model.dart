import 'package:dhbwstudentapp/common/data/preferences/app_theme_enum.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';

class RootViewModel extends BaseViewModel {
  final PreferencesProvider _preferencesProvider;

  AppTheme _appTheme;
  AppTheme get appTheme => _appTheme;

  bool _isOnboarding;
  bool get isOnboarding => _isOnboarding;

  RootViewModel(this._preferencesProvider);

  Future<void> loadFromPreferences() async {
    var darkMode = await _preferencesProvider.appTheme();

    _appTheme = darkMode;
    _isOnboarding = await _preferencesProvider.isFirstStart();

    notifyListeners("appTheme");
    notifyListeners("isOnboarding");
  }

  Future<void> setAppTheme(AppTheme value) async {
    await _preferencesProvider.setAppTheme(value);
    _appTheme = value;
    notifyListeners("appTheme");
  }

  Future<void> setIsOnboarding(bool value) async {
    await _preferencesProvider.setIsFirstStart(value);
    _isOnboarding = value;
    notifyListeners("isOnboarding");
  }
}
