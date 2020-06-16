import 'dart:io';

import 'package:dhbwstuttgart/common/appstart/background_initialize.dart';
import 'package:dhbwstuttgart/common/appstart/localization_initialize.dart';
import 'package:dhbwstuttgart/common/appstart/notification_schedule_changed_initialize.dart';
import 'package:dhbwstuttgart/common/appstart/notifications_initialize.dart';
import 'package:dhbwstuttgart/common/appstart/service_injector.dart';
import 'package:dhbwstuttgart/schedule/business/schedule_source_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  injectServices();

  await LocalizationInitialize.fromLanguageCode(Platform.localeName)
      .setupLocalizations();

  await NotificationsInitialize().setupNotifications();
  await BackgroundInitialize().setupBackgroundScheduling();
  NotificationScheduleChangedInitialize().setupNotification();
}

Future<void> initializeAppBackground() async {
  WidgetsFlutterBinding.ensureInitialized();

  injectServices();

  await LocalizationInitialize.fromPreferences(kiwi.Container().resolve())
      .setupLocalizations();

  await NotificationsInitialize().setupNotifications();
  await ScheduleSourceSetup().setupScheduleSource();
  BackgroundInitialize().setupBackgroundScheduling(true);
  NotificationScheduleChangedInitialize().setupNotification();
}
