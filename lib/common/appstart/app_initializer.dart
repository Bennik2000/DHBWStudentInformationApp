import 'dart:io';

import 'package:dhbwstudentapp/common/appstart/background_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/localization_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/notification_schedule_changed_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/notifications_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/service_injector.dart';
import 'package:dhbwstudentapp/common/iap/in_app_purchase_manager.dart';
import 'package:dhbwstudentapp/native/widget/widget_update_callback.dart';
import 'package:dhbwstudentapp/schedule/background/calendar_synchronizer.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:kiwi/kiwi.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_provider.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:timezone/data/latest.dart' as tz;

bool isInitialized = false;

///
/// Initializes the app for foreground or background use. After this call
/// everything will be loaded and the startup process is completed
///
Future<void> initializeApp(bool isBackground) async {
  print("Initialize requested. Is background: $isBackground");

  if (isInitialized) {
    print("Already initialized. Abort.");
    return;
  }

  injectServices(isBackground);

  tz.initializeTimeZones();

  if (isBackground) {
    await LocalizationInitialize.fromPreferences(KiwiContainer().resolve())
        .setupLocalizations();
  } else {
    await LocalizationInitialize.fromLanguageCode(Platform.localeName)
        .setupLocalizations();
  }

  if (!isBackground) {
    KiwiContainer().registerInstance(
      InAppPurchaseManager(
        KiwiContainer().resolve(),
        KiwiContainer().resolve(),
      ),
    );
  }

  WidgetUpdateCallback(KiwiContainer().resolve())
      .registerCallback(KiwiContainer().resolve());

  NotificationsInitialize().setupNotifications();
  BackgroundInitialize().setupBackgroundScheduling();
  NotificationScheduleChangedInitialize().setupNotification();

  if (isBackground) {
    var setup = KiwiContainer().resolve<ScheduleSourceProvider>();
    setup.setupScheduleSource();
  }

  // Callback-Function for synchronizing the device calendar with the schedule, when schedule is updated
  CalendarSynchronizer calendarSynchronizer = new CalendarSynchronizer(
      KiwiContainer().resolve<ScheduleProvider>(),
      KiwiContainer().resolve<ScheduleSourceProvider>(),
      KiwiContainer().resolve<PreferencesProvider>());

  calendarSynchronizer.registerSynchronizationCallback();
  calendarSynchronizer.scheduleSyncInAFewSeconds();

  isInitialized = true;
  print("Initialization finished");
}
