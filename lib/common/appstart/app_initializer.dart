import 'dart:io';

import 'package:dhbwstudentapp/common/appstart/background_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/localization_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/notification_schedule_changed_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/notifications_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/service_injector.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_setup.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

bool isInitialized = false;

///
/// Initializes the app for foreground or background use. After this call
/// everything will be loaded
///
Future<void> initializeApp(bool isBackground) async {
  print("Initialize requested. Is background: $isBackground");

  if (isInitialized) {
    print("Already initialized. Abort.");
    return;
  }

  WidgetsFlutterBinding.ensureInitialized();

  injectServices(isBackground);

  if (isBackground) {
    await LocalizationInitialize.fromPreferences(KiwiContainer().resolve())
        .setupLocalizations();
  } else {
    await LocalizationInitialize.fromLanguageCode(Platform.localeName)
        .setupLocalizations();
  }

  await NotificationsInitialize().setupNotifications();
  await BackgroundInitialize().setupBackgroundScheduling();
  NotificationScheduleChangedInitialize().setupNotification();

  if (isBackground) {
    await ScheduleSourceSetup(
      KiwiContainer().resolve(),
      KiwiContainer().resolve(),
    ).setupScheduleSource();
  }

  isInitialized = true;
  print("Initialization finished");
}
