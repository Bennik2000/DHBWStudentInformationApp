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
  var widget;

  for (var route in navigationEntries) {
    if (route.route == settings.name) {
      widget = route.buildRoute;
      break;
    }
  }

  if (widget == null) {
    print("Failed to navigate to: " + settings.name);
    widget = (BuildContext context) => Placeholder();
  }

  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

Route<dynamic> generateRoute(RouteSettings settings) {
  var target;

  switch (settings.name) {
    case "/onboarding":
      target = OnboardingPage();
      break;
    case "/":
      target = MainPage();
      break;
    case "/settings":
      target = SettingsPage();
      break;
  }

  return MaterialPageRoute(builder: (_) => target);
}
