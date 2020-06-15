import 'package:dhbwstuttgart/common/background/background_work_scheduler.dart';
import 'package:dhbwstuttgart/common/util/date_utils.dart';
import 'package:dhbwstuttgart/schedule/background/background_schedule_update.dart';
import 'package:dhbwstuttgart/schedule/ui/notification/next_day_information_notification.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class BackgroundInitialize {
  Future<void> setupBackgroundScheduling([bool isHeadless = false]) async {
    var scheduler = BackgroundWorkScheduler();

    if (!isHeadless) scheduler.setupBackgroundScheduling();

    scheduler.registerTaskCallback(
      "BackgroundScheduleUpdate",
      BackgroundScheduleUpdate(
        kiwi.Container().resolve(),
        kiwi.Container().resolve(),
      ),
    );
    scheduler.schedulePeriodic(Duration(hours: 2), "BackgroundScheduleUpdate");

    // TODO: Verify if background task is still executed
    // TODO: Register handlers in headless mode

    scheduler.registerTaskCallback(
      "NextDayInformationNotification",
      NextDayInformationNotification(
          kiwi.Container().resolve(), kiwi.Container().resolve(), scheduler),
    );
    scheduler.scheduleOneShotTaskAt(
      toTimeOfDayInFuture(DateTime.now(), 20, 0),
      "NextDayInformationNotification",
    );

    kiwi.Container().registerInstance(scheduler);
  }
}
