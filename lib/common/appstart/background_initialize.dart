import 'package:dhbwstudentapp/common/background/background_work_scheduler.dart';
import 'package:dhbwstudentapp/schedule/background/background_schedule_update.dart';
import 'package:dhbwstudentapp/schedule/ui/notification/next_day_information_notification.dart';
import 'package:kiwi/kiwi.dart';
import 'package:kiwi/kiwi.dart';

class BackgroundInitialize {
  Future<void> setupBackgroundScheduling() async {
    var scheduler = BackgroundWorkScheduler();

    KiwiContainer().registerInstance(scheduler);

    var tasks = [
      BackgroundScheduleUpdate(
        KiwiContainer().resolve(),
        KiwiContainer().resolve(),
        KiwiContainer().resolve(),
      ),
      NextDayInformationNotification(
        KiwiContainer().resolve(),
        KiwiContainer().resolve(),
        KiwiContainer().resolve(),
        KiwiContainer().resolve(),
      ),
    ];

    for (var task in tasks) {
      scheduler.registerTask(task);

      KiwiContainer().registerInstance(
        task,
        name: task.getName(),
      );

      await task.schedule();
    }
  }
}
