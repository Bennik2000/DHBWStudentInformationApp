import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model.dart';
import 'package:flutter/material.dart';

class OnboardingButtonBar extends StatelessWidget {
  final OnboardingViewModel viewModel;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const OnboardingButtonBar({
    Key? key,
    required this.viewModel,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
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
          : TextButton.icon(
              onPressed: onPrevious,
              icon: Icon(Icons.navigate_before),
              label: Text(L.of(context).onboardingBackButton.toUpperCase()),
            ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    String buttonText;
    if (viewModel.isLastStep) {
      buttonText = L.of(context).onboardingFinishButton;
    } else {
      buttonText = L.of(context).onboardingNextButton;
    }
    if (!viewModel.currentPageValid) {
      buttonText = L.of(context).onboardingSkipButton;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      child: TextButton.icon(
        key: ValueKey(buttonText),
        onPressed: onNext,
        icon: viewModel.isLastStep
            ? Icon(Icons.arrow_forward)
            : Icon(Icons.navigate_next),
        label: Text(buttonText.toUpperCase()),
      ),
    );
  }
}
