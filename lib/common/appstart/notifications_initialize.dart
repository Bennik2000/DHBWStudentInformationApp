import 'dart:io';

import 'package:dhbwstudentapp/common/ui/notification_api.dart';
import 'package:kiwi/kiwi.dart';

class NotificationsInitialize {
  Future<void> setupNotifications() async {
    if (Platform.isAndroid) {
      var notificationApi = NotificationApi();

      await notificationApi.initialize();

      KiwiContainer().registerInstance(notificationApi);
    } else {
      KiwiContainer().registerInstance<NotificationApi>(VoidNotificationApi());
    }
  }
}
