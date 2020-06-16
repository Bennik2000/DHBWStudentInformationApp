import 'package:dhbwstuttgart/common/background/background_work_scheduler.dart';
import 'package:dhbwstuttgart/common/util/date_utils.dart';
import 'package:dhbwstuttgart/schedule/background/background_schedule_update.dart';
import 'package:dhbwstuttgart/schedule/ui/notification/next_day_information_notification.dart';
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

    if (isHeadless) return;

    scheduler.setupBackgroundScheduling();
    scheduler.schedulePeriodic(
        Duration(minutes: 30), "BackgroundScheduleUpdate");

    // TODO: Verify if background task is still executed
    // TODO: Register handlers in headless mode

    scheduler.scheduleOneShotTaskAt(
      toTimeOfDayInFuture(DateTime.now(), 20, 0),
      "NextDayInformationNotification",
    );

    kiwi.Container().registerInstance(scheduler);
  }
}
