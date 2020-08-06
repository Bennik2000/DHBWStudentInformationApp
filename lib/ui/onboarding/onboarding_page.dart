import 'package:animations/animations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/root_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/dualis_login_page.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/onboarding_button_bar.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/onboarding_page_background.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/rapla_url_page.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/select_app_features.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  OnboardingViewModel viewModel;

  _OnboardingPageState();

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

    _controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider(
      value: viewModel,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            buildContent(),
            OnboardingPageBackground(controller: _controller.view),
          ],
        ),
        resizeToAvoidBottomPadding: false,
      ),
    );
  }

  Widget buildContent() {
    return GestureDetector(
      onPanEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 10) {
          navigateBack(context);
        } else if (details.velocity.pixelsPerSecond.dx < -10) {
          navigateNext(context);
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 140, 0, 90),
        child: PropertyChangeConsumer(
          builder: (BuildContext context, OnboardingViewModel model, _) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buildActiveOnboardingPage(model),
                OnboardingButtonBar(
                  onPrevious: () {
                    navigateBack(context);
                  },
                  onNext: () {
                    navigateNext(context);
                  },
                  viewModel: viewModel,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildActiveOnboardingPage(OnboardingViewModel model) {
    var contentWidgets = {
      OnboardingSteps.Start: () => SelectAppFeaturesWidget(
            viewModel: viewModel,
          ),
      OnboardingSteps.Rapla: () => RaplaUrlPage(),
      OnboardingSteps.Dualis: () => DualisLoginCredentialsPage(),
    };

    Widget body = Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: contentWidgets[model.currentPage](),
    );

    if (model.currentViewModel != null) {
      body = PropertyChangeProvider(
        key: ValueKey(model.currentStep),
        value: model.currentViewModel,
        child: body,
      );
    }

    return IntrinsicHeight(
      child: PageTransitionSwitcher(
        reverse: !model.didStepForward,
        duration: Duration(milliseconds: 300),
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) =>
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

  void navigateNext(BuildContext context) {
    if (viewModel.currentStep == viewModel.onboardingSteps - 1) {
      viewModel.save();

      var rootViewModel =
          PropertyChangeProvider.of<RootViewModel>(context).value;

      rootViewModel.setIsOnboarding(false);

      Navigator.of(context).pushReplacementNamed("/");
    } else {
      viewModel.nextPage();
    }
  }

  void navigateBack(BuildContext context) {
    viewModel.previousPage();
  }
}
