import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_rapla_view_model.dart';

enum OnboardingSteps {
  Start,
  Rapla,
  Dualis,
}

class OnboardingViewModel extends BaseViewModel {
  final PreferencesProvider preferencesProvider;
  final OnboardingRaplaViewModel onboardingRaplaViewModel;

  Map<OnboardingSteps, bool> usedAppFeatures = {
    OnboardingSteps.Start: true,
    OnboardingSteps.Rapla: true,
    OnboardingSteps.Dualis: true,
  };

  bool get useRapla => usedAppFeatures[OnboardingSteps.Rapla];
  bool get useDualis => usedAppFeatures[OnboardingSteps.Dualis];

  int get onboardingSteps => 1 + (useRapla ? 1 : 0) + (useDualis ? 1 : 0);

  int _currentStep = 0;
  int get currentStep => _currentStep;

  OnboardingSteps _currentPage = OnboardingSteps.Start;
  OnboardingSteps get currentPage => _currentPage;

  bool _didStepForward = true;
  bool get didStepForward => _didStepForward;

  OnboardingViewModel(this.preferencesProvider)
      : onboardingRaplaViewModel =
            OnboardingRaplaViewModel(preferencesProvider);

  void setUseRapla(bool useRapla) {
    usedAppFeatures[OnboardingSteps.Rapla] = useRapla;
    notifyListeners("useRapla");
  }

  void setUseDualis(bool useDualis) {
    usedAppFeatures[OnboardingSteps.Dualis] = useDualis;
    notifyListeners("useDualis");
  }

  Future<void> finishOnboarding() async {
    if (useRapla) {
      await onboardingRaplaViewModel.save();
    }

    await preferencesProvider.setIsFirstStart(false);
  }

  void previousPage() {
    if (_currentStep > 0) {
      _currentStep--;
      _didStepForward = false;
      _setCurrentPage();
      notifyListeners("currentStep");
    }
  }

  void nextPage() {
    if (_currentStep < onboardingSteps - 1) {
      _currentStep++;
      _didStepForward = true;
      _setCurrentPage();
      notifyListeners("currentStep");
    }
  }

  void _setCurrentPage() {
    var activeFeatures = <OnboardingSteps>[];

    for (var feature in OnboardingSteps.values) {
      if (usedAppFeatures[feature]) {
        activeFeatures.add(feature);
      }
    }

    _currentPage = activeFeatures[_currentStep];
  }
}
