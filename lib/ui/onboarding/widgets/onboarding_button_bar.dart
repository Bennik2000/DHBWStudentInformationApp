import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/dots_indicator.dart';
import 'package:flutter/material.dart';

class OnboardingButtonBar extends StatelessWidget {
  final OnboardingViewModel viewModel;
  final Function onNext;
  final Function onPrevious;

  const OnboardingButtonBar({
    Key key,
    @required this.viewModel,
    @required this.onNext,
    @required this.onPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          fit: FlexFit.tight,
          flex: 2,
          child: _buildPreviousButton(context),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: DotsIndicator(
            currentStep: viewModel.currentStep,
            numberSteps: viewModel.onboardingSteps,
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 2,
          child: _buildNextButton(context),
        )
      ],
    );
  }

  Widget _buildPreviousButton(BuildContext context) {
    bool isFirstPage = viewModel.currentStep == 0;

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 100),
      child: isFirstPage
          ? Container()
          : FlatButton.icon(
              onPressed: onPrevious,
              icon: Icon(Icons.navigate_before),
              label: Text(L.of(context).onboardingBackButton.toUpperCase()),
              textColor: Theme.of(context).accentColor,
            ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    bool isLastPage = viewModel.currentStep == viewModel.onboardingSteps - 1;

    var buttonText;
    var buttonColor = Theme.of(context).accentColor;

    if (isLastPage) {
      buttonText = L.of(context).onboardingFinishButton;
    } else {
      buttonText = L.of(context).onboardingNextButton;
    }
    if (!viewModel.canStepNext) {
      buttonText = L.of(context).onboardingSkipButton;
      buttonColor = Theme.of(context).disabledColor;
    }

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 100),
      child: FlatButton.icon(
        key: ValueKey(buttonText),
        onPressed: onNext,
        icon:
            isLastPage ? Icon(Icons.arrow_forward) : Icon(Icons.navigate_next),
        label: Text(buttonText.toUpperCase()),
        textColor: buttonColor,
      ),
    );
  }
}
