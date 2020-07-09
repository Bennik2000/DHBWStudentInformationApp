import 'package:dhbwstudentapp/common/appstart/app_initializer.dart';
import 'package:dhbwstudentapp/common/background/task_callback.dart';
import 'package:kiwi/kiwi.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundWorkScheduler {
  Map<String, TaskCallback> _taskCallbacks = {};

  BackgroundWorkScheduler() {
    _setupBackgroundScheduling();
  }

  Future<void> scheduleOneShotTaskIn(
      Duration delay, String id, String name) async {
    print(
      "Scheduling one shot task: $id. With a delay of ${delay.inMinutes} minutes.",
    );

    await Workmanager.registerOneOffTask(
      id,
      name,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      initialDelay: delay,
    );
  }

  Future<void> scheduleOneShotTaskAt(
    DateTime date,
    String id,
    String name,
  ) async {
    await scheduleOneShotTaskIn(date.difference(DateTime.now()), id, name);
  }

  Future<void> cancelTask(String id) async {
    await Workmanager.cancelByUniqueName(id);
    print("Cancelled task $id");
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

  void registerTask(TaskCallback task) {
    _taskCallbacks[task.getName()] = task;
  }

  Future<void> executeTask(String id) async {
    await _taskCallbacks[id]?.run();
  }

  static Future<bool> backgroundTaskMain(taskId, inputData) async {
    try {
      print("Background task started: $taskId with data: $inputData");

      await initializeApp(true);

      BackgroundWorkScheduler scheduler = KiwiContainer().resolve();

      await scheduler.executeTask(taskId);
    } catch (e, trace) {
      print("Background task failed:");
      print(e);
      print(trace);
      return false;
    }

    print("Background task finished successfully");

    return true;
  }

  Future<void> _setupBackgroundScheduling() async {
    print("Initialize background scheduling");

    await Workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }
}

void callbackDispatcher() {
  Workmanager.executeTask(BackgroundWorkScheduler.backgroundTaskMain);
}
