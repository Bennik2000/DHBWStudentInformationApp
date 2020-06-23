import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_diff_calculator.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_provider.dart';
import 'package:dhbwstudentapp/schedule/ui/notification/schedule_changed_notification.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class NotificationScheduleChangedInitialize {
  void setupNotification() {
    var provider = kiwi.Container().resolve<ScheduleProvider>();

    provider.addScheduleEntryChangedCallback(_scheduleChangedCallback);
  }

  Future<void> _scheduleChangedCallback(ScheduleDiff scheduleDiff) async {
    PreferencesProvider preferences = kiwi.Container().resolve();
    var doNotify = await preferences.getNotifyAboutScheduleChanges();

    if (!doNotify) return;

    var notification = ScheduleChangedNotification(
      kiwi.Container().resolve(),
      kiwi.Container().resolve(),
    );
    notification.showNotification(scheduleDiff);

    return Future.value();
  }
}
