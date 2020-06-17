import 'package:dhbwstudentapp/common/background/background_work_scheduler.dart';
import 'package:dhbwstudentapp/common/background/task_callback.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/notification_api.dart';
import 'package:dhbwstudentapp/common/util/date_utils.dart';
import 'package:dhbwstudentapp/common/util/string_utils.dart';
import 'package:dhbwstudentapp/schedule/data/schedule_entry_repository.dart';
import 'package:intl/intl.dart';

class NextDayInformationNotification extends TaskCallback {
  final NotificationApi _notificationApi;
  final ScheduleEntryRepository _scheduleEntryRepository;
  final BackgroundWorkScheduler _scheduler;
  final L _localization;

  NextDayInformationNotification(
    this._notificationApi,
    this._scheduleEntryRepository,
    this._scheduler,
    this._localization,
  );

  @override
  Future<void> run() async {
    var nextSchedule = toTimeOfDay(tomorrow(DateTime.now()), 20, 00);
    await _scheduler.scheduleOneShotTaskAt(
      nextSchedule,
      "NextDayInformationNotification" + DateFormat.yMd().format(nextSchedule),
      "NextDayInformationNotification",
    );

    var now = DateTime.now();

    var nextScheduleEntry =
        await _scheduleEntryRepository.queryNextScheduleEntry(now);

    var message;
    var format = DateFormat.Hm();

    if (nextScheduleEntry == null) {
      message = _localization.notificationNextClassNoNextClassMessage;
    } else {
      var daysToNextEntry = toStartOfDay(nextScheduleEntry.start)
          .difference(toStartOfDay(now))
          .inDays;

      if (daysToNextEntry == 0) {
        message = interpolate(
          _localization.notificationNextClassNextClassAtMessage,
          [
            nextScheduleEntry.title,
            format.format(nextScheduleEntry.start),
          ],
        );
      } else if (daysToNextEntry == 1) {
        message = interpolate(
          _localization.notificationNextClassTomorrow,
          [
            nextScheduleEntry.title,
            format.format(nextScheduleEntry.start),
          ],
        );
      } else {
        return;
      }
    }

    await _notificationApi.showNotification(
        _localization.notificationNextClassTitle, message);
  }
}
