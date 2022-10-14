import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

///
/// Provides methods to display native notifications
///
class NotificationApi {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ///
  /// Initialize the notifications. You can't show any notifications before you
  /// call this method
  ///
  Future<void> initialize() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
      'outline_event_note_24',
    );

    final initializationSettingsIOS = IOSInitializationSettings(
      // TODO: [Leptopoda] the below always returns null so why register it?
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  ///
  /// Show a notification with the given title and message
  ///
  Future showNotification(String title, String? message, [int? id]) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Notifications',
      'Notifications',
      channelDescription: 'This is the main notification channel',
      icon: 'outline_event_note_24',
      channelShowBadge: false,
      color: Colors.red,
      enableLights: true,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const iOSPlatformChannelSpecifics = IOSNotificationDetails();

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
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
          int id, String? title, String? body, String? payload,) =>
      Future.value();

  Future selectNotification(String? payload) => Future.value();
}

///
/// This class implements the methods of the NotificationApi with empty stubs
///
class VoidNotificationApi implements NotificationApi {
  @override
  FlutterLocalNotificationsPlugin get _localNotificationsPlugin =>
      throw UnimplementedError();

  @override
  Future<void> initialize() {
    return Future.value();
  }

  @override
  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload,) {
    return Future.value();
  }

  @override
  Future selectNotification(String? payload) {
    return Future.value();
  }

  @override
  Future showNotification(String title, String? message, [int? id]) {
    return Future.value();
  }
}
