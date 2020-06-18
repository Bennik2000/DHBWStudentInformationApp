import 'dart:io';

import 'package:dhbwstudentapp/common/appstart/background_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/localization_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/notification_schedule_changed_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/notifications_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/service_injector.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

bool isInitialized = false;

///
/// Initializes the app for foreground use. After this call everything will be
/// loaded
///
Future<void> initializeApp() async {
  print("Initialize requested");

  if (isInitialized) {
    print("Already initialized. Abort.");
    return;
  }

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  injectServices();

  await LocalizationInitialize.fromLanguageCode(Platform.localeName)
      .setupLocalizations();

  await NotificationsInitialize().setupNotifications();
  await BackgroundInitialize().setupBackgroundScheduling();
  NotificationScheduleChangedInitialize().setupNotification();

  isInitialized = true;
  print("Initialization finished");
}

///
/// Initialize the app for background use. Call this function when inside a
/// headless task. After this call everything will be loaded for background use.
///
Future<void> initializeAppForBackground() async {
  print("Initialize for Background requested");

  if (isInitialized) {
    print("Already initialized. Abort.");
    return;
  }

  WidgetsFlutterBinding.ensureInitialized();

  injectServices();

  await LocalizationInitialize.fromPreferences(kiwi.Container().resolve())
      .setupLocalizations();

  await NotificationsInitialize().setupNotifications();
  await ScheduleSourceSetup().setupScheduleSource();
  BackgroundInitialize().setupBackgroundScheduling(true);
  NotificationScheduleChangedInitialize().setupNotification();

  isInitialized = true;

  print("Initialization finished");
}
