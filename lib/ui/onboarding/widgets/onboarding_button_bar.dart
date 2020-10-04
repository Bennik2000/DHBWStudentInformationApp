import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model.dart';
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildPreviousButton(context),
          _buildNextButton(context)
        ],
      ),
    );
  }

  Widget _buildPreviousButton(BuildContext context) {
    bool isFirstPage = viewModel.stepIndex == 0;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
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
    String buttonText;
    var buttonColor = Theme.of(context).accentColor;

    if (viewModel.isLastStep) {
      buttonText = L.of(context).onboardingFinishButton;
    } else {
      buttonText = L.of(context).onboardingNextButton;
    }
    if (!viewModel.currentPageValid) {
      buttonText = L.of(context).onboardingSkipButton;
      buttonColor = Theme.of(context).disabledColor;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      child: FlatButton.icon(
        key: ValueKey(buttonText),
        onPressed: onNext,
        icon: viewModel.isLastStep
            ? Icon(Icons.arrow_forward)
            : Icon(Icons.navigate_next),
        label: Text(buttonText.toUpperCase()),
        textColor: buttonColor,
      ),
    );
  }
}
