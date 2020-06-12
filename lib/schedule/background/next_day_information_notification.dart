import 'package:dhbwstuttgart/common/background/background_work_scheduler.dart';
import 'package:dhbwstuttgart/common/i18n/localizations.dart';
import 'package:dhbwstuttgart/common/ui/notification_api.dart';
import 'package:dhbwstuttgart/common/util/date_utils.dart';
import 'package:dhbwstuttgart/common/util/string_utils.dart';
import 'package:dhbwstuttgart/schedule/data/schedule_entry_repository.dart';
import 'package:intl/intl.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class NextDayInformationNotification extends TaskCallback {
  final NotificationApi _notificationApi;
  final ScheduleEntryRepository _scheduleEntryRepository;
  final BackgroundWorkScheduler _scheduler;
  L _localization = kiwi.Container().resolve();

  NextDayInformationNotification(
    this._notificationApi,
    this._scheduleEntryRepository,
    this._scheduler,
  );

  @override
  Future<void> run() async {
    _scheduler.scheduleOneShotTaskAt(
      toTimeOfDay(tomorrow(DateTime.now()), 20, 0),
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