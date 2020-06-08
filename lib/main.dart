import 'package:dhbwstuttgart/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstuttgart/common/i18n/localizations.dart';
import 'package:dhbwstuttgart/schedule/ui/onboarding/onboarding_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:dhbwstuttgart/common/ui/colors.dart';
import 'package:dhbwstuttgart/common/ui/viewmodels/root_view_model.dart';
import 'package:dhbwstuttgart/schedule/ui/main_page.dart';
import 'package:dhbwstuttgart/service_injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  injectServices();

  bool firstStart = await isFirstStart();

  runApp(
    PropertyChangeProvider(
      child: PropertyChangeConsumer(
        properties: [
          "isDarkMode",
        ],
        builder: (BuildContext context, RootViewModel model, Set properties) =>
            MaterialApp(
          theme: ThemeData(
            brightness: model.isDarkMode ? Brightness.dark : Brightness.light,
            accentColor: ColorPalettes.main[500],
            primarySwatch: ColorPalettes.main,
          ),
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

Future<bool> isFirstStart() async {
  PreferencesProvider preferencesProvider = kiwi.Container().resolve();
  bool firstStart = await preferencesProvider.isFirstStart();
  return firstStart;
}

Future<RootViewModel> setupRootViewModel() async {
  var rootViewModel = RootViewModel(
    kiwi.Container().resolve(),
  );

  await rootViewModel.loadFromPreferences();
  return rootViewModel;
}
