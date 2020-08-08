import 'package:dhbwstudentapp/common/background/background_work_scheduler.dart';
import 'package:dhbwstudentapp/common/background/task_callback.dart';
import 'package:dhbwstudentapp/common/background/work_scheduler_service.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/notification_api.dart';
import 'package:dhbwstudentapp/common/util/date_utils.dart';
import 'package:dhbwstudentapp/common/util/string_utils.dart';
import 'package:dhbwstudentapp/schedule/data/schedule_entry_repository.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:intl/intl.dart';

class NextDayInformationNotification extends TaskCallback {
  final NotificationApi _notificationApi;
  final ScheduleEntryRepository _scheduleEntryRepository;
  final WorkSchedulerService _scheduler;
  final L _localization;

  NextDayInformationNotification(
    this._notificationApi,
    this._scheduleEntryRepository,
    this._scheduler,
    this._localization,
  );

  @override
  Future<void> run() async {
    await schedule();

    var now = DateTime.now();

    var nextScheduleEntry =
        await _scheduleEntryRepository.queryNextScheduleEntry(now);

    if (nextScheduleEntry == null) return;

    var format = DateFormat.Hm();
    var daysToNextEntry = toStartOfDay(nextScheduleEntry.start)
        .difference(toStartOfDay(now))
        .inDays;

    if (daysToNextEntry > 1) return;

    var message = _getNotificationMessage(
      daysToNextEntry,
      nextScheduleEntry,
      format,
    );

    await _notificationApi.showNotification(
      _localization.notificationNextClassTitle,
      message,
    );
  }

  _getNotificationMessage(
      int daysToNextEntry, ScheduleEntry nextScheduleEntry, DateFormat format) {
    var message;
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
    }
    return message;
  }

  @override
  Future<void> schedule() async {
    var nextSchedule = toTimeOfDayInFuture(DateTime.now(), 20, 00);
    await _scheduler.scheduleOneShotTaskAt(
      nextSchedule,
      "NextDayInformationNotification" + DateFormat.yMd().format(nextSchedule),
      "NextDayInformationNotification",
    );
  }

  @override
  Future<void> cancel() async {
    var nextSchedule = toTimeOfDayInFuture(DateTime.now(), 20, 00);
    await _scheduler.cancelTask(
      "NextDayInformationNotification" + DateFormat.yMd().format(nextSchedule),
    );
  }

  @override
  String getName() {
    return name;
  }

  static String get name => "NextDayInformationNotification";
}
