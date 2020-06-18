import 'package:dhbwstudentapp/common/background/background_work_scheduler.dart';
import 'package:dhbwstudentapp/common/util/date_utils.dart';
import 'package:dhbwstudentapp/schedule/background/background_schedule_update.dart';
import 'package:dhbwstudentapp/schedule/ui/notification/next_day_information_notification.dart';
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
    scheduler.schedulePeriodic(Duration(hours: 4), "BackgroundScheduleUpdate");

    var nextSchedule = toTimeOfDay(tomorrow(DateTime.now()), 20, 00);
    await scheduler.scheduleOneShotTaskAt(
      nextSchedule,
      "NextDayInformationNotification" + DateFormat.yMd().format(nextSchedule),
      "NextDayInformationNotification",
    );
  }
}
