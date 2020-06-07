import 'package:dhbwstuttgart/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstuttgart/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstuttgart/schedule/service/rapla/rapla_schedule_source.dart';

class OnboardingViewModel extends BaseViewModel {
  final PreferencesProvider preferencesProvider;

  String _raplaUrl;

  String get raplaUrl => _raplaUrl;
  bool urlHasError = false;

  OnboardingViewModel(this.preferencesProvider);

  void setRaplaUrl(String url) {
    _raplaUrl = url;

    notifyListeners("raplaUrl");

    validateUrl();
  }

  void validateUrl() {
    try {
      new RaplaScheduleSource().validateEndpointUrl(_raplaUrl);
      urlHasError = false;
    } catch (e) {
      urlHasError = true;
    }

    notifyListeners("urlHasError");
  }

  Future<void> finishOnboarding() async {
    await preferencesProvider.setRaplaUrl(_raplaUrl);
    await preferencesProvider.setIsFirstStart(false);
  }
}
