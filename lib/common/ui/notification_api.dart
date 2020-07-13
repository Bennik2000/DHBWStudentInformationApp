import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    var initializationSettingsAndroid = AndroidInitializationSettings(
      'outline_event_note_24',
    );

    var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    var initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  Future showNotification(String title, String message, [int id]) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Notifications',
      'Notifications',
      'This is the main notification channel',
      icon: 'outline_event_note_24',
      channelAction: AndroidNotificationChannelAction.Update,
      autoCancel: true,
      channelShowBadge: false,
      color: Colors.red,
      enableLights: true,
      enableVibration: true,
      importance: Importance.High,
      priority: Priority.High,
      ticker: 'ticker',
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );

    await _localNotificationsPlugin.show(
      // TODO: This is a quick and dirty fix. Find a better solution in the future
      id ?? Random().nextInt(1 << 30),
      title,
      message,
      platformChannelSpecifics,
      payload: "",
    );
  }

  Future onDidReceiveLocalNotification(
          int id, String title, String body, String payload) =>
      Future.value();

  Future selectNotification(String payload) => Future.value();
}
