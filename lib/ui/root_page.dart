import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/colors.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/root_view_model.dart';
import 'package:dhbwstudentapp/ui/main_page.dart';
import 'package:dhbwstudentapp/ui/onboarding/onboarding_page.dart';
import 'package:dhbwstudentapp/ui/settings/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class RootPage extends StatefulWidget {
  final RootViewModel rootViewModel;

  const RootPage({Key key, this.rootViewModel}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState(rootViewModel);
}

class _RootPageState extends State<RootPage> {
  final RootViewModel rootViewModel;

  _RootPageState(this.rootViewModel);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider(
      child: PropertyChangeConsumer(
        properties: ["isDarkMode", "isOnboarding"],
        builder: (BuildContext context, RootViewModel model, Set properties) =>
            MaterialApp(
          theme: ColorPalettes.buildTheme(model.isDarkMode),
          initialRoute: rootViewModel.isOnboarding ? "/" : "/home",
          localizationsDelegates: [
            const LocalizationDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'),
            const Locale('de'),
          ],
          routes: {
            "/": (BuildContext context) => OnboardingPage(),
            "/home": (BuildContext context) => MainPage(),
            "/settings": (BuildContext context) => SettingsPage(),
          },
        ),
      ),
      value: rootViewModel,
    );
  }
}
