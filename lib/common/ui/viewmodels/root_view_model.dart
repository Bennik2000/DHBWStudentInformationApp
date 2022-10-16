import 'package:dhbwstudentapp/common/data/preferences/app_theme_enum.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';

class RootViewModel extends BaseViewModel {
  final PreferencesProvider _preferencesProvider;

  late AppTheme _appTheme;
  AppTheme get appTheme => _appTheme;

  late bool _isOnboarding;
  bool get isOnboarding => _isOnboarding;

  RootViewModel(this._preferencesProvider);

  Future<void> loadFromPreferences() async {
    _appTheme = await _preferencesProvider.appTheme();
    _isOnboarding = await _preferencesProvider.isFirstStart();

    notifyListeners("appTheme");
    notifyListeners("isOnboarding");
  }

  Future<void> setAppTheme(AppTheme? value) async {
    if (value == null) return;

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
