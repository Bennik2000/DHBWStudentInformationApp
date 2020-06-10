import 'package:dhbwstuttgart/schedule/business/schedule_diff_calculator.dart';
import 'package:dhbwstuttgart/schedule/business/schedule_provider.dart';
import 'package:dhbwstuttgart/schedule/ui/notification/schedule_changed_notification.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class NotificationScheduleChangedInitialize {
  void setupNotification() {
    print(
        "setupNotification of notification_schedule_changed_initialize.dart called");

    var provider = kiwi.Container().resolve<ScheduleProvider>();

    provider.addScheduleEntryChangedCallback(_scheduleChangedCallback);
  }

  Future<void> _scheduleChangedCallback(ScheduleDiff scheduleDiff) {
    var notification = ScheduleChangedNotification(kiwi.Container().resolve());
    notification.showNotification(scheduleDiff);

    return Future.value();
  }
}
