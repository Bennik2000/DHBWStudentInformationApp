import 'dart:io';

import 'package:dhbwstudentapp/common/ui/notification_api.dart';
import 'package:kiwi/kiwi.dart';

///
/// Initializes the notification api and injects it into the container.
/// Note: Notifications only work reliably on android. iOS and other platforms
/// won't show the notification
///
class NotificationsInitialize {
  const NotificationsInitialize();

  Future<void> setupNotifications() async {
    if (Platform.isAndroid) {
      final notificationApi = NotificationApi();

      KiwiContainer().registerInstance(notificationApi);

      await notificationApi.initialize();
    } else {
      KiwiContainer()
          .registerInstance<NotificationApi>(const VoidNotificationApi());
    }
  }
}
