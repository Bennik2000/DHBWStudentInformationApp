import 'dart:io';

import 'package:dhbwstudentapp/ui/root_page.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:dhbwstudentapp/common/appstart/app_initializer.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/root_view_model.dart';
import 'package:kiwi/kiwi.dart';
import 'package:flutter/material.dart';

void main() async {
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  await initializeApp(false);
  await saveLastStartLanguage();

  runApp(RootPage(
    rootViewModel: await loadRootViewModel(),
  ));
}

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
