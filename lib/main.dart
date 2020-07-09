import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:dhbwstudentapp/common/appstart/app_initializer.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/schedule/ui/onboarding/onboarding_page.dart';
import 'package:dhbwstudentapp/common/ui/colors.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/root_view_model.dart';
import 'package:dhbwstudentapp/schedule/ui/main_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kiwi/kiwi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

void main() async {
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  await initializeApp(false);

  await saveLastStartLanguage();
  bool firstStart = await isFirstStart();

  runApp(
    PropertyChangeProvider(
      child: PropertyChangeConsumer(
        properties: [
          "isDarkMode",
        ],
        builder: (BuildContext context, RootViewModel model, Set properties) =>
            MaterialApp(
          theme: ColorPalettes.buildTheme(model.isDarkMode),
          home: firstStart ? OnboardingPage() : MainPage(),
          localizationsDelegates: [
            const LocalizationDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'),
            const Locale('de'),
          ],
        ),
      ),
      value: await setupRootViewModel(),
    ),
  );
}

Future<void> saveLastStartLanguage() async {
  PreferencesProvider preferencesProvider = KiwiContainer().resolve();
  await preferencesProvider.setLastUsedLanguageCode(Platform.localeName);
}

Future<bool> isFirstStart() async {
  PreferencesProvider preferencesProvider = KiwiContainer().resolve();
  bool firstStart = await preferencesProvider.isFirstStart();
  return firstStart;
}

Future<RootViewModel> setupRootViewModel() async {
  var rootViewModel = RootViewModel(
    KiwiContainer().resolve(),
  );

  await rootViewModel.loadFromPreferences();
  return rootViewModel;
}
