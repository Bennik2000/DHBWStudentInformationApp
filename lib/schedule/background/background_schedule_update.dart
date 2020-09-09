import 'package:dhbwstudentapp/common/background/task_callback.dart';
import 'package:dhbwstudentapp/common/background/work_scheduler_service.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/common/util/date_utils.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_provider.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';

class BackgroundScheduleUpdate extends TaskCallback {
  final ScheduleProvider scheduleProvider;
  final ScheduleSource scheduleSource;
  final PreferencesProvider preferencesProvider;
  final WorkSchedulerService scheduler;

  BackgroundScheduleUpdate(
    this.scheduleProvider,
    this.scheduleSource,
    this.preferencesProvider,
    this.scheduler,
  );

  Future updateSchedule() async {
    if (!await _canUpdateSchedule()) {
      print("Cancelled update due to an invalid schedule source endpoint url");
      return;
    }

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

  Future<bool> _canUpdateSchedule() async {
    try {
      scheduleSource
          .validateEndpointUrl(await preferencesProvider.getRaplaUrl());

      return true;
    } catch (_) {
      return false;
    }
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
      const Duration(hours: 4),
      getName(),
    );
  }

  @override
  String getName() {
    return "BackgroundScheduleUpdate";
  }
}
