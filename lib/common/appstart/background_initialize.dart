import 'package:dhbwstuttgart/common/background/background_work_scheduler.dart';
import 'package:dhbwstuttgart/common/util/date_utils.dart';
import 'package:dhbwstuttgart/schedule/background/background_schedule_update.dart';
import 'package:dhbwstuttgart/schedule/ui/notification/next_day_information_notification.dart';
import 'package:intl/intl.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class BackgroundInitialize {
  Future<void> setupBackgroundScheduling([bool isHeadless = false]) async {
    var scheduler = BackgroundWorkScheduler();

    scheduler.registerTaskCallback(
      "BackgroundScheduleUpdate",
      BackgroundScheduleUpdate(
        kiwi.Container().resolve(),
        kiwi.Container().resolve(),
      ),
    );
    scheduler.registerTaskCallback(
      "NextDayInformationNotification",
      NextDayInformationNotification(
        kiwi.Container().resolve(),
        kiwi.Container().resolve(),
        scheduler,
        kiwi.Container().resolve(),
      ),
    );

    kiwi.Container().registerInstance(scheduler);

    if (isHeadless) return;

    scheduler.setupBackgroundScheduling();
    scheduler.schedulePeriodic(
        Duration(hours: 4), "BackgroundScheduleUpdate");

    // TODO: Verify if background task is still executed
    // TODO: Register handlers in headless mode

    var nextSchedule = toTimeOfDay(tomorrow(DateTime.now()), 20, 00);
    await scheduler.scheduleOneShotTaskAt(
      nextSchedule,
      "NextDayInformationNotification" + DateFormat.yMd().format(nextSchedule),
      "NextDayInformationNotification",
    );
  }
}
