import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model_base.dart';

class DualisLoginViewModel extends OnboardingStepViewModel {
  final PreferencesProvider preferencesProvider;
  final DualisService dualisService;

  Credentials? credentials;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _loginSuccess = false;
  bool get loginSuccess => _loginSuccess;

  DualisLoginViewModel(this.preferencesProvider, this.dualisService);

  @override
  void setIsValid(bool isValid) {
    if (credentials == null) {
      super.setIsValid(false);
    } else {
      super.setIsValid(isValid);
    }
  }

  Future<void> testCredentials(Credentials credentials) async {
    try {
      _isLoading = true;

      notifyListeners("isLoading");

      _loginSuccess =
          await dualisService.login(credentials) == LoginResult.LoggedIn;
      setIsValid(_loginSuccess);
    } catch (ex) {
      setIsValid(false);
    } finally {
      _isLoading = false;
    }
    notifyListeners("isLoading");
    notifyListeners("passwordOrUsernameWrong");
  }

  @override
  Future<void> save() async {
    if (!isValid) return;

    await preferencesProvider.setStoreDualisCredentials(true);

    // To improve the onboarding experience we do not await this call because
    // it may take a few seconds
    preferencesProvider.storeDualisCredentials(credentials!);
  }
}
