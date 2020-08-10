import 'package:dhbwstudentapp/common/background/task_callback.dart';

abstract class WorkSchedulerService {
  Future<void> scheduleOneShotTaskIn(Duration delay, String id, String name);

  Future<void> scheduleOneShotTaskAt(
    DateTime date,
    String id,
    String name,
  );

  Future<void> cancelTask(String id);

  Future<void> schedulePeriodic(
    Duration delay,
    String id, [
    bool needsNetwork = false,
  ]);

  void registerTask(TaskCallback task);

  Future<void> executeTask(String id);

  bool isSchedulingAvailable();
}
