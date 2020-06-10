import 'package:dhbwstuttgart/common/ui/notification_api.dart';
import 'package:dhbwstuttgart/schedule/business/schedule_diff_calculator.dart';
import 'package:intl/intl.dart';

class ScheduleChangedNotification {
  final NotificationApi notificationApi;

  ScheduleChangedNotification(this.notificationApi);

  void showNotification(ScheduleDiff scheduleDiff) {
    for (var entry in scheduleDiff.addedEntries) {
      var message =
          "Weitere Vorlesung: ${entry.title} am ${DateFormat.yMd().format(entry.start)}" +
              " um ${DateFormat.Hm().format(entry.start)}";

      notificationApi.showNotification("Weitere Vorlesung", message);
    }

    for (var entry in scheduleDiff.removedEntries) {
      var message =
          "${entry.title} am ${DateFormat.yMd().format(entry.start)}" +
              " um ${DateFormat.Hm().format(entry.start)} entfällt";

      notificationApi.showNotification("Vorlesung entfällt", message);
    }

    for (var entry in scheduleDiff.updatedEntries) {
      var message =
          "${entry.entry.title} (${DateFormat.yMd().format(entry.entry.start)}) hat sich geändert.";

      notificationApi.showNotification("Vorlesung geändert", message);
    }
  }
}
