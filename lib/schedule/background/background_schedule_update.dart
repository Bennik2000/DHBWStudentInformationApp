import 'package:dhbwstudentapp/common/background/background_work_scheduler.dart';
import 'package:dhbwstudentapp/common/background/task_callback.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/common/util/date_utils.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_provider.dart';

class BackgroundScheduleUpdate extends TaskCallback {
  final ScheduleProvider scheduleProvider;
  final PreferencesProvider preferencesProvider;
  final BackgroundWorkScheduler scheduler;

  BackgroundScheduleUpdate(
    this.scheduleProvider,
    this.preferencesProvider,
    this.scheduler,
  );

  Future updateSchedule() async {
    var today = toDayOfWeek(toStartOfDay(DateTime.now()), DateTime.monday);
    var end = addDays(today, 7 * 3);

    var cancellationToken = CancellationToken();

    await scheduleProvider.getUpdatedSchedule(
      today,
      end,
      cancellationToken,
    );

    print("Finished updating schedule");
  }

  @override
  Future<void> run() async {
    await updateSchedule();
  }

  @override
  Future<void> cancel() async {
    await scheduler.cancelTask(getName());
  }

  @override
  Future<void> schedule() async {
    await scheduler.schedulePeriodic(
      Duration(hours: 4),
      getName(),
    );
  }

  @override
  String getName() {
    return "BackgroundScheduleUpdate";
  }
}
