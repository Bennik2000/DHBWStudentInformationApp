import 'package:dhbwstudentapp/common/background/background_work_scheduler.dart';
import 'package:dhbwstudentapp/schedule/background/background_schedule_update.dart';
import 'package:dhbwstudentapp/schedule/ui/notification/next_day_information_notification.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class BackgroundInitialize {
  Future<void> setupBackgroundScheduling() async {
    var scheduler = BackgroundWorkScheduler();

    kiwi.Container().registerInstance(scheduler);

    var tasks = [
      BackgroundScheduleUpdate(
        kiwi.Container().resolve(),
        kiwi.Container().resolve(),
        kiwi.Container().resolve(),
      ),
      NextDayInformationNotification(
        kiwi.Container().resolve(),
        kiwi.Container().resolve(),
        kiwi.Container().resolve(),
        kiwi.Container().resolve(),
      ),
    ];

    for (var task in tasks) {
      scheduler.registerTask(task);

      kiwi.Container().registerInstance(
        task,
        name: task.getName(),
      );

      await task.schedule();
    }
  }
}
