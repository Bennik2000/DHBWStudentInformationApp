import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model_base.dart';

class OnboardingDualisViewModel extends OnboardingViewModelBase {
  final PreferencesProvider preferencesProvider;
  final DualisService dualisService;

  String username;
  String password;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _loginSuccess = false;
  bool get loginSuccess => _loginSuccess;

  bool _passwordOrUsernameWrong = false;
  bool get passwordOrUsernameWrong => _passwordOrUsernameWrong;

  OnboardingDualisViewModel(this.preferencesProvider, this.dualisService);

  Future<void> testCredentials(String username, String password) async {
    this.username = username;
    this.password = password;

    try {
      _isLoading = true;

      notifyListeners("isLoading");

      _loginSuccess =
          await dualisService.login(username, password) == LoginResult.LoggedIn;
      _passwordOrUsernameWrong = !_loginSuccess;
      setIsValid(_loginSuccess);
    } catch (ex) {
      setIsValid(false);
      _passwordOrUsernameWrong = true;
    } finally {
      _isLoading = false;
    }
    notifyListeners("isLoading");
    notifyListeners("passwordOrUsernameWrong");
  }

  @override
  Future<void> save() async {
    await preferencesProvider.setStoreDualisCredentials(true);
    await preferencesProvider.storeDualisCredentials(Credentials(
      username,
      password,
    ));
  }
}
