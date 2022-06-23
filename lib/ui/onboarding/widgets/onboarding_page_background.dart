import 'package:dhbwstudentapp/common/math/math.dart';
import 'package:dhbwstudentapp/common/ui/colors.dart';
import 'package:dhbwstudentapp/common/util/platform_util.dart';
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
          begin: PlatformUtil.isPhone() ? -32 : -10,
          end: PlatformUtil.isPhone() ? -10 : -5,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.0,
              1,
              curve: Curves.linear,
            ),
          ),
        ),
        angleTopForeground = Tween<double>(
          begin: PlatformUtil.isPhone() ? -14 : -5,
          end: PlatformUtil.isPhone() ? 25 : 10,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
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
            curve: const Interval(
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
            curve: const Interval(
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
              width: 15000,
              height: 500,
              color: colorOnboardingDecorationForeground(context),
            ),
            offset: const Offset(20, -450),
          ),
          angle: toRadian(angleTopForeground.value),
        ),
        Transform.rotate(
          child: Transform.translate(
            child: Container(
              width: 1500,
              height: 500,
              color: colorOnboardingDecorationBackground(context),
            ),
            offset: const Offset(20, -480),
          ),
          angle: toRadian(angleTopBackground.value),
        ),
        PlatformUtil.isPhone()
            ? Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 90,
                  width: double.infinity,
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
              )
            : Container(),
        PlatformUtil.isPhone()
            ? Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 90,
                  width: double.infinity,
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
              )
            : Container(),
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
