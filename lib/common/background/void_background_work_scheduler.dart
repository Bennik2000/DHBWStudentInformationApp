import 'package:dhbwstudentapp/common/background/task_callback.dart';
import 'package:dhbwstudentapp/common/background/work_scheduler_service.dart';

class VoidBackgroundWorkScheduler extends WorkSchedulerService {
  VoidBackgroundWorkScheduler() {
    print("Background scheduling is not available!");
  }

  @override
  Future<void> scheduleOneShotTaskIn(Duration delay, String id, String name) {
    print(
      "Did not schedule one shot task: $id. With a delay of ${delay.inMinutes} minutes.",
    );

    return Future.value();
  }

  @override
  Future<void> scheduleOneShotTaskAt(
    DateTime date,
    String id,
    String name,
  ) async {
    await scheduleOneShotTaskIn(date.difference(DateTime.now()), id, name);
  }

  @override
  Future<void> cancelTask(String id) {
    print("Cancelled task $id");

    return Future.value();
  }

  @override
  Future<void> schedulePeriodic(
    Duration delay,
    String id, [
    bool needsNetwork = false,
  ]) {
    print(
      "Did not schedule periodic task: $id. With a delay of ${delay.inMinutes} minutes. Requires network: $needsNetwork",
    );

    return Future.value();
  }

  @override
  void registerTask(TaskCallback task) {}

  @override
  Future<void> executeTask(String id) {
    return Future.value();
  }

  @override
  bool isSchedulingAvailable() {
    return false;
  }
}
