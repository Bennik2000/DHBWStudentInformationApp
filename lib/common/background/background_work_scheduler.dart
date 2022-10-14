import 'package:dhbwstudentapp/common/appstart/app_initializer.dart';
import 'package:dhbwstudentapp/common/background/task_callback.dart';
import 'package:dhbwstudentapp/common/background/work_scheduler_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:workmanager/workmanager.dart';

///
/// Provides functionality to register tasks which will execute after a
/// specified amount of time or at a specific time. Depending on the android
/// version and device the tasks will be executed even if the app is closed.
///
class BackgroundWorkScheduler extends WorkSchedulerService {
  final Map<String, TaskCallback> _taskCallbacks = {};
  final Workmanager workmanager = Workmanager();

  BackgroundWorkScheduler() {
    _setupBackgroundScheduling();
  }

  ///
  /// Schedules a task after a specified amount of time. The id must be unique.
  /// If you schedule two tasks with the same id, the first one will be canceled.
  ///
  @override
  Future<void> scheduleOneShotTaskIn(
      Duration delay, String id, String name,) async {
    print(
      "Scheduling one shot task: $id. With a delay of ${delay.inMinutes} minutes.",
    );

    await workmanager.registerOneOffTask(
      id,
      name,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      initialDelay: delay,
    );
  }

  ///
  /// Schedules a task a specific point in time. The id must be unique.
  /// If you schedule two tasks with the same id, the first one will be canceled.
  /// The name determines the callback which will be called.
  ///
  @override
  Future<void> scheduleOneShotTaskAt(
    DateTime date,
    String id,
    String name,
  ) async {
    await scheduleOneShotTaskIn(date.difference(DateTime.now()), id, name);
  }

  ///
  /// Cancels the task with the given id
  ///
  @override
  Future<void> cancelTask(String id) async {
    await workmanager.cancelByUniqueName(id);
    print("Cancelled task $id");
  }

  ///
  /// Schedules one task which will be executed periodically. The first
  /// execution will be after the specified delay.
  /// The name determines the callback which will be called.
  ///
  @override
  Future<void> schedulePeriodic(
    Duration delay,
    String id, [
    bool needsNetwork = false,
  ]) async {
    print(
      "Scheduling periodic task: $id. With a delay of ${delay.inMinutes} minutes. Requires network: $needsNetwork",
    );

    await workmanager.registerPeriodicTask(
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

  ///
  /// Registers a callback function for when a task was executed
  ///
  @override
  void registerTask(TaskCallback task) {
    _taskCallbacks[task.getName()] = task;
  }

  @override
  Future<void> executeTask(String id) async {
    await _taskCallbacks[id]?.run();
  }

  ///
  /// Entry point for when a background task is executed
  ///
  static Future<bool> backgroundTaskMain(taskId, inputData) async {
    try {
      print("Background task started: $taskId with data: $inputData");

      await initializeApp(true);

      WorkSchedulerService scheduler = KiwiContainer().resolve();

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

    await workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  @override
  bool isSchedulingAvailable() {
    return true;
  }
}

void callbackDispatcher() {
  Workmanager().executeTask(BackgroundWorkScheduler.backgroundTaskMain);
}
