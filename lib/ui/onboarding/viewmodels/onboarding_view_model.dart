import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_dualis_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_rapla_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model_base.dart';

enum OnboardingSteps {
  Start,
  Rapla,
  Dualis,
}

class OnboardingViewModel extends BaseViewModel {
  final PreferencesProvider preferencesProvider;
  final DualisService dualisService;
  final ScheduleSourceProvider scheduleSourceProvider;

  Map<OnboardingSteps, bool> usedAppFeatures = {
    OnboardingSteps.Start: true,
    OnboardingSteps.Rapla: true,
    OnboardingSteps.Dualis: true,
  };

  final Map<OnboardingSteps, OnboardingViewModelBase> _viewModels = {};
  OnboardingViewModelBase get currentViewModel => _viewModels[_currentPage];

  bool get useRapla => usedAppFeatures[OnboardingSteps.Rapla];
  bool get useDualis => usedAppFeatures[OnboardingSteps.Dualis];

  int get onboardingSteps => 1 + (useRapla ? 1 : 0) + (useDualis ? 1 : 0);

  int _currentStep = 0;
  int get currentStep => _currentStep;

  OnboardingSteps _currentPage = OnboardingSteps.Start;
  OnboardingSteps get currentPage => _currentPage;

  bool _didStepForward = true;
  bool get didStepForward => _didStepForward;

  bool get canStepNext {
    return currentViewModel?.isValid ?? true;
  }

  OnboardingViewModel(
    this.preferencesProvider,
    this.dualisService,
    this.scheduleSourceProvider,
  ) {
    _viewModels[OnboardingSteps.Rapla] =
        OnboardingRaplaViewModel(preferencesProvider, scheduleSourceProvider);

    _viewModels[OnboardingSteps.Dualis] =
        OnboardingDualisViewModel(preferencesProvider, dualisService);

    for (var vm in _viewModels.values) {
      vm.addListener(() {
        notifyListeners("canStepNext");
      });
    }
  }

  void setUseRapla(bool useRapla) {
    usedAppFeatures[OnboardingSteps.Rapla] = useRapla;
    notifyListeners("useRapla");
  }

  void setUseDualis(bool useDualis) {
    usedAppFeatures[OnboardingSteps.Dualis] = useDualis;
    notifyListeners("useDualis");
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
    final activeFeatures = <OnboardingSteps>[];

    for (var feature in OnboardingSteps.values) {
      if (usedAppFeatures[feature]) {
        activeFeatures.add(feature);
      }
    }

    _currentPage = activeFeatures[_currentStep];

    notifyListeners("currentPage");
    notifyListeners("currentViewModel");
  }

  void save() {
    for (var viewModel in _viewModels.values) {
      viewModel.save();
    }
  }
}
