import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/schedule/service/rapla/rapla_schedule_source.dart';

class OnboardingRaplaViewModel extends BaseViewModel {
  final PreferencesProvider preferencesProvider;

  String _raplaUrl;
  String get raplaUrl => _raplaUrl;

  bool urlHasError = false;

  OnboardingRaplaViewModel(this.preferencesProvider);

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

  Future<void> save() async {
    await preferencesProvider.setRaplaUrl(_raplaUrl);
  }
}
