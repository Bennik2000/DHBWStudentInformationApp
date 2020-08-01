import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_diff_calculator.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_provider.dart';
import 'package:dhbwstudentapp/schedule/ui/notification/schedule_changed_notification.dart';
import 'package:kiwi/kiwi.dart';

class NotificationScheduleChangedInitialize {
  void setupNotification() {
    var provider = KiwiContainer().resolve<ScheduleProvider>();

    provider.addScheduleEntryChangedCallback(_scheduleChangedCallback);
  }

  Future<void> _scheduleChangedCallback(ScheduleDiff scheduleDiff) async {
    PreferencesProvider preferences = KiwiContainer().resolve();
    var doNotify = await preferences.getNotifyAboutScheduleChanges();

    if (!doNotify) return;

    var notification = ScheduleChangedNotification(
      KiwiContainer().resolve(),
      KiwiContainer().resolve(),
    );
    notification.showNotification(scheduleDiff);

    return Future.value();
  }
}
