import 'package:dhbwstuttgart/common/background/background_work_scheduler.dart';
import 'package:dhbwstuttgart/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstuttgart/common/util/cancellation_token.dart';
import 'package:dhbwstuttgart/common/util/date_utils.dart';
import 'package:dhbwstuttgart/schedule/business/schedule_provider.dart';

class BackgroundScheduleUpdate extends TaskCallback {
  final ScheduleProvider scheduleProvider;
  final PreferencesProvider preferencesProvider;

  BackgroundScheduleUpdate(
    this.scheduleProvider,
    this.preferencesProvider,
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
}
