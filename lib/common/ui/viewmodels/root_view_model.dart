import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';

class RootViewModel extends BaseViewModel {
  final PreferencesProvider _preferencesProvider;

  bool _isDarkMode;
  bool get isDarkMode => _isDarkMode;

  RootViewModel(this._preferencesProvider);

  Future<void> loadFromPreferences() async {
    _isDarkMode = await _preferencesProvider.isDarkMode();

    notifyListeners("isDarkMode");
  }

  Future<void> setIsDarkMode(bool value) async {
    await _preferencesProvider.setIsDarkMode(value);
    _isDarkMode = value;
    notifyListeners("isDarkMode");
  }
}
