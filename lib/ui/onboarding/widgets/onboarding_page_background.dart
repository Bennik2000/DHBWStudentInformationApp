import 'package:dhbwstudentapp/common/math/math.dart';
import 'package:dhbwstudentapp/common/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingPageBackground extends StatelessWidget {
  final Animation<double> controller;
  final Animation<double> angleTopForeground;
  final Animation<double> angleTopBackground;
  final Animation<double> bottomForeground;
  final Animation<double> bottomBackground;

  final Map<Brightness, String> foreground = {
    Brightness.light: "assets/onboarding_bottom_foreground.png",
    Brightness.dark: "assets/onboarding_bottom_foreground_dark.png",
  };

  final Map<Brightness, String> background = {
    Brightness.light: "assets/onboarding_bottom_background.png",
    Brightness.dark: "assets/onboarding_bottom_background_dark.png",
  };

  OnboardingPageBackground({Key key, this.controller})
      : angleTopBackground = Tween<double>(
          begin: -32,
          end: -10,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              1,
              curve: Curves.linear,
            ),
          ),
        ),
        angleTopForeground = Tween<double>(
          begin: -14,
          end: 25,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              1,
              curve: Curves.linear,
            ),
          ),
        ),
        bottomBackground = Tween<double>(
          begin: 0,
          end: -25,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              1,
              curve: Curves.linear,
            ),
          ),
        ),
        bottomForeground = Tween<double>(
          begin: 50,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              1,
              curve: Curves.linear,
            ),
          ),
        ),
        super(key: key);

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Stack(
      children: <Widget>[
        Transform.rotate(
          child: Transform.translate(
            child: Container(
              width: 4000,
              height: 200,
              color: colorOnboardingDecorationForeground(context),
            ),
            offset: Offset(100, -150),
          ),
          angle: toRadian(angleTopForeground.value),
        ),
        Transform.rotate(
          child: Transform.translate(
            child: Container(
              width: 3000,
              height: 200,
              color: colorOnboardingDecorationBackground(context),
            ),
            offset: Offset(0, -170),
          ),
          angle: toRadian(angleTopBackground.value),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: Offset(bottomBackground.value, 20),
            child: Transform.scale(
              scale: 1.5,
              child: Image.asset(
                background[Theme.of(context).brightness],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: Offset(bottomForeground.value, 20),
            child: Transform.scale(
              scale: 1.5,
              child: Image.asset(
                foreground[Theme.of(context).brightness],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
