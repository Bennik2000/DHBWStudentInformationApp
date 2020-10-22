import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/logging/analytics.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/onboardin_step.dart';

typedef OnboardingFinished = void Function();

class OnboardingViewModel extends BaseViewModel {
  final PreferencesProvider preferencesProvider;
  final OnboardingFinished _onboardingFinished;

  final List<String> steps = [
    "selectSource",
    "rapla",
    "mannheim",
    "ical",
    "dualis",
  ];

  final Map<String, OnboardingStep> pages = {
    "selectSource": SelectSourceOnboardingStep(),
    "rapla": RaplaOnboardingStep(),
    "ical": IcalOnboardingStep(),
    "dualis": DualisCredentialsOnboardingStep(),
    "mannheim": MannheimOnboardingStep(),
  };

  final Map<String, int> stepsBackstack = {};

  int _stepIndex = 0;
  int get stepIndex => _stepIndex;

  String get currentStep => steps[_stepIndex];

  bool get currentPageValid => pages[currentStep].viewModel().isValid;
  bool get isLastStep => _stepIndex >= steps.length - 1;

  get onboardingSteps => steps.length;

  bool _didStepForward = true;
  bool get didStepForward => _didStepForward;

  OnboardingViewModel(
    this.preferencesProvider,
    this._onboardingFinished,
  ) {
    for (var page in pages.values) {
      page.viewModel().addListener(() {
        notifyListeners("currentPageValid");
      }, ["isValid"]);
    }

    analytics.logTutorialBegin();
    analytics.setUserProperty(name: "onboarding_finished", value: "false");
  }

  void previousPage() {
    var lastPage = stepsBackstack.keys.last;

    _stepIndex = stepsBackstack[lastPage];

    stepsBackstack.remove(lastPage);

    _didStepForward = false;

    notifyListeners();
  }

  Future<void> nextPage() async {
    if (_stepIndex == steps.length - 1) {
      stepsBackstack[currentStep] = _stepIndex;
      await finishOnboarding();
      return;
    }

    var nextDesiredStep = pages[currentStep].nextStep();

    stepsBackstack[currentStep] = _stepIndex;

    if (nextDesiredStep == null) {
      nextDesiredStep = steps[_stepIndex + 1];
    }

    while (nextDesiredStep != currentStep) {
      _stepIndex++;
    }

    _didStepForward = true;

    notifyListeners();
  }

  Future<void> finishOnboarding() async {
    for (var step in stepsBackstack.keys) {
      await pages[step].viewModel().save();
    }

    _onboardingFinished?.call();

    await analytics.logTutorialComplete();
    await analytics.setUserProperty(name: "onboarding_finished", value: "true");
  }
}
