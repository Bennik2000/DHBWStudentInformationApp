import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_diff_calculator.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_provider.dart';
import 'package:dhbwstudentapp/schedule/ui/notification/schedule_changed_notification.dart';
import 'package:kiwi/kiwi.dart';

///
/// Initializes the notification for when the schedule changed
///
class NotificationScheduleChangedInitialize {
  void setupNotification() {
    final provider = KiwiContainer().resolve<ScheduleProvider>();

    provider.addScheduleEntryChangedCallback(_scheduleChangedCallback);
  }

  Future<void> _scheduleChangedCallback(ScheduleDiff scheduleDiff) async {
    final PreferencesProvider preferences = KiwiContainer().resolve();
    final doNotify = await preferences.getNotifyAboutScheduleChanges();

    if (!doNotify) return;

    final notification = ScheduleChangedNotification(
      KiwiContainer().resolve(),
      KiwiContainer().resolve(),
    );
    notification.showNotification(scheduleDiff);

    return Future.value();
  }
}
