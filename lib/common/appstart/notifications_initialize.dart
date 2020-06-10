import 'package:dhbwstuttgart/common/ui/notification_api.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class NotificationsInitialize {
  Future<void> setupNotifications() async {
    var notificationApi = NotificationApi();

    await notificationApi.initialize();

    kiwi.Container().registerInstance(notificationApi);
  }
}
