import 'package:dhbwstudentapp/dualis/ui/dualis_navigation_entry.dart';
import 'package:dhbwstudentapp/information/ui/useful_information_navigation_entry.dart';
import 'package:dhbwstudentapp/schedule/ui/schedule_navigation_entry.dart';
import 'package:dhbwstudentapp/ui/main_page.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:dhbwstudentapp/ui/onboarding/onboarding_page.dart';
import 'package:dhbwstudentapp/ui/settings/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final List<NavigationEntry> navigationEntries = [
  ScheduleNavigationEntry(),
  DualisNavigationEntry(),
  UsefulInformationNavigationEntry(),
];

Route<dynamic> generateDrawerRoute(RouteSettings settings) {
  print("=== === === === === === Navigating to: ${settings.name}");

  var widget;

  for (var route in navigationEntries) {
    if (route.route == settings.name) {
      widget = route.buildRoute;
      break;
    }
  }

  if (widget == null) {
    print("Failed to navigate to: " + settings.name);
    widget = (BuildContext context) => Container();
  }

  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => widget(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: Container(
          child: child,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      );
    },
  );
}

Route<dynamic> generateRoute(RouteSettings settings) {
  print("=== === === === === === Navigating to: ${settings.name}");
  var target;

  switch (settings.name) {
    case "onboarding":
      target = OnboardingPage();
      break;
    case "main":
      target = MainPage();
      break;
    case "settings":
      target = SettingsPage();
      break;
    default:
      print("Failed to navigate to: " + settings.name);
      target = Container();
  }

  return MaterialPageRoute(builder: (_) => target);
}
