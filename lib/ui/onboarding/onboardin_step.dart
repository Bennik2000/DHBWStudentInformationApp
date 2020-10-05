import 'package:dhbwstudentapp/ui/onboarding/viewmodels/dualis_login_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/rapla_url_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model_base.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/select_source_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/dualis_login_page.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/rapla_url_page.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/select_source_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:kiwi/kiwi.dart';

abstract class OnboardingStep {
  final String id;

  OnboardingStep(this.id);

  Widget buildContent(BuildContext context);

  OnboardingStepViewModel viewModel();

  String nextStep();
}

class SelectSourceOnboardingStep extends OnboardingStep {
  final SelectSourceViewModel _viewModel = SelectSourceViewModel(
    KiwiContainer().resolve(),
  );

  SelectSourceOnboardingStep() : super("start");

  @override
  Widget buildContent(BuildContext context) {
    return SelectSourcePage();
  }

  @override
  String nextStep() {
    return _viewModel.nextStep();
  }

  @override
  OnboardingStepViewModel viewModel() {
    return _viewModel;
  }
}

class DualisCredentialsOnboardingStep extends OnboardingStep {
  final DualisLoginViewModel _viewModel = DualisLoginViewModel(
    KiwiContainer().resolve(),
    KiwiContainer().resolve(),
  );

  DualisCredentialsOnboardingStep() : super("dualis");

  @override
  Widget buildContent(BuildContext context) {
    return DualisLoginCredentialsPage();
  }

  @override
  String nextStep() {
    return null;
  }

  @override
  OnboardingStepViewModel viewModel() {
    return _viewModel;
  }
}

class RaplaOnboardingStep extends OnboardingStep {
  RaplaUrlViewModel _viewModel = RaplaUrlViewModel(
    KiwiContainer().resolve(),
    KiwiContainer().resolve(),
  );

  RaplaOnboardingStep() : super("rapla");

  @override
  Widget buildContent(BuildContext context) {
    return RaplaUrlPage();
  }

  @override
  String nextStep() {
    return null;
  }

  @override
  OnboardingStepViewModel viewModel() {
    return _viewModel;
  }
}