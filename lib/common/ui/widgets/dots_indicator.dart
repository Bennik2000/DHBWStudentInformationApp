import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  final int numberSteps;
  final int currentStep;

  const DotsIndicator(
      {Key? key, required this.numberSteps, required this.currentStep,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dots = <Widget>[];

    for (int i = 0; i < numberSteps; i++) {
      dots.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Container(
            width: 7.0,
            height: 7.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == currentStep
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).disabledColor,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dots,
    );
  }
}
