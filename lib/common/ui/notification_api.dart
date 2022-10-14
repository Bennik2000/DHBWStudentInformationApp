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
    var initializationSettingsAndroid = const AndroidInitializationSettings(
      'outline_event_note_24',
    );

    var initializationSettingsIOS = IOSInitializationSettings(
      // TODO: [Leptopoda] the below always returns null so why register it?
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    var initializationSettings = InitializationSettings(
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
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Notifications',
      'Notifications',
      channelDescription: 'This is the main notification channel',
      icon: 'outline_event_note_24',
      channelAction: AndroidNotificationChannelAction.createIfNotExists,
      autoCancel: true,
      channelShowBadge: false,
      color: Colors.red,
      enableLights: true,
      enableVibration: true,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
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
