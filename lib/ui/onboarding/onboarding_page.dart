import 'package:animations/animations.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/onboarding_page_background.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/dots_indicator.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/onboarding_rapla_url.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/onboarding_select_app_features.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:kiwi/kiwi.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  OnboardingViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = new OnboardingViewModel(KiwiContainer().resolve());

    viewModel.addListener(
      () async {
        await _controller.animateTo(
            viewModel.currentStep / viewModel.onboardingSteps,
            curve: Curves.ease,
            duration: Duration(milliseconds: 300));
      },
      ["currentStep"],
    );

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider(
      value: viewModel,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            OnboardingPageBackground(controller: _controller.view),
            buildContent(),
          ],
        ),
        resizeToAvoidBottomPadding: false,
      ),
    );
  }

  Padding buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 150, 32, 110),
      child: PropertyChangeConsumer(
        builder: (BuildContext context, OnboardingViewModel model, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buildActiveOnboardingPage(model),
              buildButtonBar(model),
            ],
          );
        },
      ),
    );
  }

  Widget buildActiveOnboardingPage(OnboardingViewModel model) {
    var contentWidgets = {
      OnboardingSteps.Start: () =>
          SelectAppFeaturesWidget(viewModel: viewModel),
      OnboardingSteps.Rapla: () => RaplaUrlPage(),
      OnboardingSteps.Dualis: () => Placeholder(),
    };

    return Expanded(
      child: PageTransitionSwitcher(
        reverse: !model.didStepForward,
        duration: Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            SharedAxisTransition(
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
        ),
        child: contentWidgets[model.currentPage](),
      ),
    );
  }

  Row buildButtonBar(OnboardingViewModel model) {
    return Row(
      children: <Widget>[
        FlatButton.icon(
          onPressed: viewModel.previousPage,
          icon: Icon(Icons.navigate_before),
          label: Text("Back".toUpperCase()),
          textColor: Colors.red,
        ),
        Expanded(
          child: DotsIndicator(
            currentStep: model.currentStep,
            numberSteps: model.onboardingSteps,
          ),
        ),
        FlatButton.icon(
          onPressed: viewModel.nextPage,
          icon: Icon(Icons.navigate_next),
          label: Text("Next".toUpperCase()),
          textColor: Colors.red,
        ),
      ],
    );
  }
}
