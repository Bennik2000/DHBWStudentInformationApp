import 'package:background_fetch/background_fetch.dart';
import 'package:dhbwstuttgart/common/appstart/background_initialize.dart';
import 'package:dhbwstuttgart/common/appstart/localization_initialize.dart';
import 'package:dhbwstuttgart/common/appstart/notification_schedule_changed_initialize.dart';
import 'package:dhbwstuttgart/common/appstart/notifications_initialize.dart';
import 'package:dhbwstuttgart/common/appstart/service_injector.dart';
import 'package:dhbwstuttgart/schedule/business/schedule_source_setup.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

void backgroundFetchHeadlessMain(taskId) async {
  try {
    print("Headless background task started");
    WidgetsFlutterBinding.ensureInitialized();

    injectServices();
    await LocalizationInitialize.fromPreferences(kiwi.Container().resolve())
        .setupLocalizations();
    await NotificationsInitialize().setupNotifications();
    await ScheduleSourceSetup().setupScheduleSource();
    BackgroundInitialize().setupBackgroundScheduling(true);
    NotificationScheduleChangedInitialize().setupNotification();

    await backgroundTaskMain(taskId);
  } catch (e, trace) {
    print("Headless background task failed:");
    print(e);
    print(trace);
  } finally {
    print("Headless background task finished");
    BackgroundFetch.finish(taskId);
  }
}

Future<void> backgroundTaskMain(taskId) async {
  print("Executing $taskId");
  BackgroundWorkScheduler scheduler = kiwi.Container().resolve();
  await scheduler.executeTask(taskId);
}

abstract class TaskCallback {
  Future<void> run();
}

class BackgroundWorkScheduler {
  DateTime _initializationTime = DateTime.now();
  Map<String, TaskCallback> _taskCallbacks = {};

  Future<void> setupBackgroundScheduling() async {
    _setupHeadless();
    await _configureBackgroundFetch();
  }

  Future<void> scheduleOneShotTaskIn(Duration delay, String id) async {
    await BackgroundFetch.scheduleTask(
      TaskConfig(
        delay: delay.inMilliseconds,
        taskId: id,
        forceAlarmManager: true,
        enableHeadless: true,
        startOnBoot: true,
        stopOnTerminate: false,
        periodic: false,
      ),
    );
  }

  Future<void> scheduleOneShotTaskAt(DateTime date, String id) async {
    await scheduleOneShotTaskIn(date.difference(DateTime.now()), id);
  }

  Future<void> schedulePeriodic(Duration delay, String id,
      [bool needsNetwork = false]) async {
    await BackgroundFetch.scheduleTask(
      TaskConfig(
        delay: delay.inMilliseconds,
        taskId: id,
        forceAlarmManager: true,
        enableHeadless: true,
        startOnBoot: true,
        stopOnTerminate: false,
        requiredNetworkType: needsNetwork
            ? NetworkType.ANY
            : NetworkType.NONE, // TODO: Verify this
        periodic: true,
      ),
    );
  }

  void registerTaskCallback(String id, TaskCallback callback) {
    _taskCallbacks[id] = callback;
  }

  Future<void> executeTask(String id) async {
    await _taskCallbacks[id]?.run();
  }

  void _setupHeadless() {
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessMain);
  }

  Future<void> _configureBackgroundFetch() async {
    try {
      print("Configuring background fetch");
      _initializationTime = DateTime.now();

      var status = await BackgroundFetch.configure(
          BackgroundFetchConfig(
            minimumFetchInterval: 60 * 12,
            enableHeadless: true,
            stopOnTerminate: false,
            startOnBoot: true,
          ),
          _backgroundFetchTask);

      if (status != BackgroundFetch.STATUS_AVAILABLE) {
        print("Background fetch is not available!");
        return;
      }
    } catch (e) {
      print("Failed to initialize background fetch: $e");
    }
  }

  void _backgroundFetchTask(taskId) async {
    try {
      print("Background task started");

      if (DateTime.now().difference(_initializationTime).inSeconds < 10) {
        print(
            "Abort background fetch because it was fired right after initialization");
      } else {
        await backgroundTaskMain(taskId);
      }
    } catch (e, trace) {
      print("Background task failed:");
      print(e);
      print(trace);
    } finally {
      print("Background task finished");
      BackgroundFetch.finish(taskId);
    }
  }
}
