import 'package:dhbwstudentapp/dualis/ui/login/dualis_login_page.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_dualis_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model_base.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/select_source_onboarding_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/dualis_login_page.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/select_app_features.dart';
import 'package:flutter/cupertino.dart';
import 'package:kiwi/kiwi.dart';

abstract class OnboardingStep {
  final String id;

  OnboardingStep(this.id);

  Widget buildContent(BuildContext context);

  OnboardingStepViewModel viewModel();

  List<String> nextStep();
}

class SelectSourceOnboardingStep extends OnboardingStep {
  final SelectSourceOnboardingViewModel _viewModel =
      SelectSourceOnboardingViewModel();

  SelectSourceOnboardingStep() : super("start");

  @override
  Widget buildContent(BuildContext context) {
    return SelectAppFeaturesWidget();
  }

  @override
  List<String> nextStep() {
    _viewModel.nextStep();
  }

  @override
  OnboardingStepViewModel viewModel() {
    return _viewModel;
  }
}

class DualisCredentialsOnboardingStep extends OnboardingStep {
  final OnboardingDualisViewModel _viewModel = OnboardingDualisViewModel(
    KiwiContainer().resolve(),
    KiwiContainer().resolve(),
  );

  DualisCredentialsOnboardingStep() : super("dualis");

  @override
  Widget buildContent(BuildContext context) {
    return DualisLoginCredentialsPage();
  }

  @override
  List<String> nextStep() {
    return [];
  }

  @override
  OnboardingStepViewModel viewModel() {
    return _viewModel;
  }
}
