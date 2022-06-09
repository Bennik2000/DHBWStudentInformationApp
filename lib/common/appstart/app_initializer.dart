import 'dart:developer';
import 'dart:io';

import 'package:dhbwstudentapp/common/appstart/background_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/localization_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/notification_schedule_changed_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/notifications_initialize.dart';
import 'package:dhbwstudentapp/common/appstart/service_injector.dart';
import 'package:dhbwstudentapp/common/iap/in_app_purchase_manager.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:dhbwstudentapp/native/widget/widget_update_callback.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:dhbwstudentapp/schedule/data/schedule_entry_entity.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:kiwi/kiwi.dart';

import '../../date_management/data/calendar_access.dart';
import '../../schedule/business/schedule_provider.dart';
import '../data/preferences/preferences_provider.dart';
import '../util/cancellation_token.dart';

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
  var preferenceProvider = KiwiContainer().resolve<PreferencesProvider>();
  KiwiContainer()
      .resolve<ScheduleProvider>()
      .addScheduleUpdatedCallback((schedule, start, end) async {
      print('in ScheduleUpdatedCallback!');
    if (await preferenceProvider.isCalendarSyncEnabled()) {
      print('CalendarSync is ENABLED');

      // print(start);
      // print(end);
      inspect(schedule);
      List<DateEntry> listDateEntries;
      schedule.entries.forEach((element) {
        // DateEntry d = DateEntry(comment: element.details, databaseName: 'DHBW', dateAndTime: );

      },);

      // CalendarAccess().addOrUpdateDates();

    }
  });

  // trigger ScheduleUpdatedCallback 10 seconds after the app started
  Future.delayed(Duration(seconds: 10), () {
    print('getUpdatedSchedule after10 Seconds');
    var scheduleProvider = KiwiContainer().resolve<ScheduleProvider>();
    scheduleProvider.getUpdatedSchedule(
      DateTime.now(),
      DateTime.now().add(Duration(days: 60)),
      CancellationToken(),
    );
  });

  isInitialized = true;
  print("Initialization finished");
}
