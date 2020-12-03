import 'dart:io';

import 'package:dhbwstudentapp/common/appstart/background_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/localization_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/notification_schedule_changed_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/notifications_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/service_injector.dart';
import 'package:dhbwstudentapp/common/iap/in_app_purchase_helper.dart';
import 'package:dhbwstudentapp/native/widget/android_schedule_today_widget_schedule_update_callback.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
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

  injectServices(isBackground);

  if (isBackground) {
    await LocalizationInitialize.fromPreferences(KiwiContainer().resolve())
        .setupLocalizations();
  } else {
    await LocalizationInitialize.fromLanguageCode(Platform.localeName)
        .setupLocalizations();
  }

  if (!isBackground) {
    KiwiContainer().registerInstance(
      InAppPurchaseHelper(KiwiContainer().resolve()),
    );
    KiwiContainer().resolve<InAppPurchaseHelper>().initialize();
  }

  AndroidScheduleTodayWidgetScheduleUpdateCallback()
      .registerCallback(KiwiContainer().resolve());

  NotificationsInitialize().setupNotifications();
  BackgroundInitialize().setupBackgroundScheduling();
  NotificationScheduleChangedInitialize().setupNotification();

  if (isBackground) {
    var setup = KiwiContainer().resolve<ScheduleSourceProvider>();
    setup.setupScheduleSource();
  }

  isInitialized = true;
  print("Initialization finished");
}
