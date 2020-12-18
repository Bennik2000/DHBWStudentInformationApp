import 'dart:io';

import 'package:dhbwstudentapp/ui/root_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:dhbwstudentapp/common/appstart/app_initializer.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/root_view_model.dart';
import 'package:kiwi/kiwi.dart';
import 'package:flutter/material.dart';

import 'common/util/platform_util.dart';

///
/// Main entry point for the app
///
void main() async {
  // Setup the flutter bindings and the error reporting as early as possible
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await initializeApp(false);

  saveLastStartLanguage();

  await PlatformUtil.initializePortraitLandscapeMode();

  runApp(RootPage(
    rootViewModel: await loadRootViewModel(),
  ));
}

///
/// Save the current language in the preferences.
/// The language of the last app start is used for the background initialization.
/// When the app runs in the background this is an easy way to get the
/// used language
///
Future<void> saveLastStartLanguage() async {
  PreferencesProvider preferencesProvider = KiwiContainer().resolve();
  await preferencesProvider.setLastUsedLanguageCode(Platform.localeName);
}

Future<RootViewModel> loadRootViewModel() async {
  var rootViewModel = RootViewModel(
    KiwiContainer().resolve(),
  );

  await rootViewModel.loadFromPreferences();
  return rootViewModel;
}
