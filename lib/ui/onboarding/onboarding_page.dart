import 'package:animations/animations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/root_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model_base.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/onboarding_button_bar.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/onboarding_page_background.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late OnboardingViewModel viewModel;

  _OnboardingPageState();

  @override
  void initState() {
    super.initState();

    viewModel = OnboardingViewModel(
      KiwiContainer().resolve(),
      _onboardingFinished,
    );

    viewModel.addListener(
      () async {
        await _controller.animateTo(
            viewModel.stepIndex! / viewModel.onboardingSteps,
            curve: Curves.ease,
            duration: const Duration(milliseconds: 300),);
      },
    );

    _controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider<OnboardingViewModel, String>(
      value: viewModel,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _buildContent(),
            OnboardingPageBackground(controller: _controller.view),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return GestureDetector(
      onPanEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 10) {
          _navigateBack(context);
        } else if (details.velocity.pixelsPerSecond.dx < -10) {
          _navigateNext(context);
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 120, 0, 90),
            child: PropertyChangeConsumer<OnboardingViewModel, String>(
              builder: (BuildContext context, OnboardingViewModel? model, _) {
                return Column(
                  children: <Widget>[
                    Expanded(child: _buildActiveOnboardingPage(model!)),
                    OnboardingButtonBar(
                      onPrevious: () {
                        _navigateBack(context);
                      },
                      onNext: () {
                        _navigateNext(context);
                      },
                      viewModel: viewModel,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveOnboardingPage(OnboardingViewModel model) {
    final currentStep = model.pages[model.currentStep]!;
    final contentWidget = currentStep.buildContent(context);

    Widget body = Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: contentWidget,
    );

    body = PropertyChangeProvider<OnboardingStepViewModel, String>(
      key: ValueKey(model.currentStep),
      value: currentStep.viewModel(),
      child: body,
    );

    return IntrinsicHeight(
      child: PageTransitionSwitcher(
        reverse: !model.didStepForward,
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

  void _navigateNext(BuildContext context) {
    viewModel.nextPage();
  }

  void _navigateBack(BuildContext context) {
    viewModel.previousPage();
  }

  void _onboardingFinished() {
    final rootViewModel =
        PropertyChangeProvider.of<RootViewModel, String>(context)!.value;
    rootViewModel.setIsOnboarding(false);

    Navigator.of(context).pushReplacementNamed("main");
  }
}
