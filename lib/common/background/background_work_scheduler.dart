import 'package:dhbwstuttgart/common/appstart/app_initializer.dart';
import 'package:dhbwstuttgart/common/background/task_callback.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:workmanager/workmanager.dart';

class BackgroundWorkScheduler {
  Map<String, TaskCallback> _taskCallbacks = {};

  Future<void> setupBackgroundScheduling() async {
    print("Initialize background scheduling");

    await Workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
  }

  Future<void> scheduleOneShotTaskIn(Duration delay, String id) async {
    print(
      "Scheduling one shot task: $id. With a delay of ${delay.inMinutes} minutes.",
    );

    await Workmanager.registerOneOffTask(
      id,
      id,
      existingWorkPolicy: ExistingWorkPolicy.keep,
      initialDelay: delay,
    );
  }

  Future<void> scheduleOneShotTaskAt(
    DateTime date,
    String id,
  ) async {
    await scheduleOneShotTaskIn(date.difference(DateTime.now()), id);
  }

  Future<void> schedulePeriodic(
    Duration delay,
    String id, [
    bool needsNetwork = false,
  ]) async {
    print(
      "Scheduling periodic task: $id. With a delay of ${delay.inMinutes} minutes. Requires network: $needsNetwork",
    );

    await Workmanager.registerPeriodicTask(
      id,
      id,
      frequency: delay,
      existingWorkPolicy: ExistingWorkPolicy.keep,
      initialDelay: delay,
      constraints: Constraints(
        networkType:
            needsNetwork ? NetworkType.connected : NetworkType.not_required,
      ),
    );
  }

  void registerTaskCallback(String id, TaskCallback callback) {
    _taskCallbacks[id] = callback;
  }

  Future<void> executeTask(String id) async {
    await _taskCallbacks[id]?.run();
  }

  static void callbackDispatcher() {
    Workmanager.executeTask(backgroundTaskMain);
  }

  static Future<bool> backgroundTaskMain(taskId, inputData) async {
    try {
      print("Background task started: $taskId with data: $inputData");

      await initializeAppBackground();

      BackgroundWorkScheduler scheduler = kiwi.Container().resolve();

      await scheduler.executeTask(taskId);
    } catch (e, trace) {
      print("Background task failed:");
      print(e);
      print(trace);
      return false;
    } finally {
      print("Background task finished");
    }

    return true;
  }
}
