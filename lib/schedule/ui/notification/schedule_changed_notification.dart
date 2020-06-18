import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/notification_api.dart';
import 'package:dhbwstudentapp/common/util/string_utils.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_diff_calculator.dart';
import 'package:intl/intl.dart';

class ScheduleChangedNotification {
  final NotificationApi notificationApi;
  final L _localization;

  ScheduleChangedNotification(this.notificationApi, this._localization);

  void showNotification(ScheduleDiff scheduleDiff) {
    showEntriesAddedNotifications(scheduleDiff);
    showEntriesRemovedNotifications(scheduleDiff);
    showEntriesChangedNotifications(scheduleDiff);
  }

  void showEntriesChangedNotifications(ScheduleDiff scheduleDiff) {
    for (var entry in scheduleDiff.updatedEntries) {
      var message = interpolate(
        _localization.notificationScheduleChangedClass,
        [
          entry.entry.title,
          DateFormat.yMd().format(entry.entry.start),
        ],
      );

      notificationApi.showNotification(
        _localization.notificationScheduleChangedClassTitle,
        message,
      );
    }
  }

  void showEntriesRemovedNotifications(ScheduleDiff scheduleDiff) {
    for (var entry in scheduleDiff.removedEntries) {
      var message = interpolate(
        _localization.notificationScheduleChangedRemovedClass,
        [
          entry.title,
          DateFormat.yMd().format(entry.start),
          DateFormat.Hm().format(entry.start)
        ],
      );

      notificationApi.showNotification(
        _localization.notificationScheduleChangedRemovedClassTitle,
        message,
      );
    }
  }

  void showEntriesAddedNotifications(ScheduleDiff scheduleDiff) {
    for (var entry in scheduleDiff.addedEntries) {
      var message = interpolate(
        _localization.notificationScheduleChangedNewClass,
        [
          entry.title,
          DateFormat.yMd().format(entry.start),
          DateFormat.Hm().format(entry.start)
        ],
      );

      notificationApi.showNotification(
        _localization.notificationScheduleChangedNewClassTitle,
        message,
      );
    }
  }
}
