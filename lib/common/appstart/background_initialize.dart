import 'package:background_fetch/background_fetch.dart';
import 'package:dhbwstuttgart/common/appstart/notification_schedule_changed_initialize.dart';
import 'package:dhbwstuttgart/common/appstart/notifications_initialize.dart';
import 'package:dhbwstuttgart/common/appstart/service_injector.dart';
import 'package:dhbwstuttgart/schedule/background/background_schedule_update.dart';
import 'package:dhbwstuttgart/schedule/business/schedule_source_setup.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

void backgroundFetchHeadlessTask(taskId) async {
  try {
    print("Headless background task started");
    injectServices();
    await NotificationsInitialize().setupNotifications();
    await ScheduleSourceSetup().setupScheduleSource();
    NotificationScheduleChangedInitialize().setupNotification();

    await backgroundTaskMain();
  } catch (e, trace) {
    print("Headless background task failed:");
    print(e);
    print(trace);
  } finally {
    print("Headless background task finished");
    BackgroundFetch.finish(taskId);
  }
}

Future<void> backgroundTaskMain() async {
  await BackgroundScheduleUpdate(
    kiwi.Container().resolve(),
    kiwi.Container().resolve(),
  ).updateSchedule();
}

class BackgroundInitialize {
  DateTime initializationTime = DateTime.now();

  Future<void> setupBackgroundScheduling() async {
    _setupHeadless();
    await _configureBackgroundFetch();
  }

  void _setupHeadless() {
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }

  Future<void> _configureBackgroundFetch() async {
    try {
      print("Configuring background fetch");
      initializationTime = DateTime.now();

      var status = await BackgroundFetch.configure(
          BackgroundFetchConfig(
            minimumFetchInterval: 120,
            enableHeadless: true,
            stopOnTerminate: false,
            startOnBoot: true,
            requiredNetworkType: NetworkType.ANY,
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

      if (DateTime.now().difference(initializationTime).inSeconds < 10) {
        print(
            "Abort background fetch because it was fired right after initialization");
      } else {
        await backgroundTaskMain();
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
