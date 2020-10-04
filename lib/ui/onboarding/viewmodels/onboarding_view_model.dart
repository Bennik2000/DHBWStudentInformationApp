import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/onboardin_step.dart';

typedef OnboardingFinished = void Function();

class OnboardingViewModel extends BaseViewModel {
  final PreferencesProvider preferencesProvider;
  final OnboardingFinished _onboardingFinished;

  final Map<String, OnboardingStep> steps = {
    "selectSource": SelectSourceOnboardingStep(),
    "dualis": DualisCredentialsOnboardingStep(),
  };

  String _currentStep = "selectSource";
  String get currentStep => _currentStep;

  List<String> nextSteps;

  bool get canStepNext => false;

  get onboardingSteps => 2;

  OnboardingViewModel(
    this.preferencesProvider,
    this._onboardingFinished,
  );

  void previousPage() {}

  void nextPage() {
    var next = steps[currentStep].nextStep();
  }
}
