import 'package:dhbwstudentapp/common/background/task_callback.dart';
import 'package:dhbwstudentapp/common/background/work_scheduler_service.dart';

class VoidBackgroundWorkScheduler extends WorkSchedulerService {
  VoidBackgroundWorkScheduler() {
    print("Background scheduling is not available!");
  }

  Future<void> scheduleOneShotTaskIn(Duration delay, String id, String name) {
    print(
      "Did not schedule one shot task: $id. With a delay of ${delay.inMinutes} minutes.",
    );

    return Future.value();
  }

  Future<void> scheduleOneShotTaskAt(
    DateTime date,
    String id,
    String name,
  ) async {
    await scheduleOneShotTaskIn(date.difference(DateTime.now()), id, name);
  }

  Future<void> cancelTask(String id) {
    print("Cancelled task $id");

    return Future.value();
  }

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

  void registerTask(TaskCallback task) {}

  Future<void> executeTask(String id) {
    return Future.value();
  }

  @override
  bool isSchedulingAvailable() {
    return false;
  }
}
