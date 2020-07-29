import 'package:animations/animations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/root_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/dualis_login_page.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/onboarding_page_background.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/dots_indicator.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/rapla_url_page.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/select_app_features.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:kiwi/kiwi.dart';

class OnboardingPage extends StatefulWidget {
  final RootViewModel rootViewModel;

  const OnboardingPage({Key key, this.rootViewModel}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState(rootViewModel);
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final RootViewModel rootViewModel;

  AnimationController _controller;
  OnboardingViewModel viewModel;

  _OnboardingPageState(this.rootViewModel);

  @override
  void initState() {
    super.initState();

    viewModel = new OnboardingViewModel(
      KiwiContainer().resolve(),
      KiwiContainer().resolve(),
    );

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
              buildButtonBar(context, model),
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
      OnboardingSteps.Dualis: () => DualisLoginCredentialsPage(),
    };

    var childViewModel = model.currentViewModel;

    var body = contentWidgets[model.currentPage]();

    if (childViewModel != null) {
      body = PropertyChangeProvider(
        key: ValueKey(model.currentStep),
        value: childViewModel,
        child: body,
      );
    }

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
        child: body,
      ),
    );
  }

  Widget buildButtonBar(BuildContext context, OnboardingViewModel model) {
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
        buildNextButton(context)
      ],
    );
  }

  Widget buildNextButton(BuildContext context) {
    bool isLastPage = viewModel.currentStep == viewModel.onboardingSteps - 1;

    var buttonText;
    var buttonColor = Colors.red;

    if (isLastPage) {
      buttonText = "Fertig";
    } else {
      buttonText = "Weiter";
    }
    if (!viewModel.canStepNext) {
      buttonText = "Überspringen";
      buttonColor = Colors.grey;
    }

    return FlatButton.icon(
      onPressed: () {
        navigateNext(context);
      },
      icon: isLastPage ? Icon(Icons.check) : Icon(Icons.navigate_next),
      label: Text(buttonText.toUpperCase()),
      textColor: buttonColor,
    );
  }

  void navigateNext(BuildContext context) {
    if (viewModel.currentStep == viewModel.onboardingSteps - 1) {
      rootViewModel.setIsOnboarding(false);
      viewModel.save();
    } else {
      viewModel.nextPage();
    }
  }
}
