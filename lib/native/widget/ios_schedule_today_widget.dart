import 'package:flutter/services.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';

class IOSScheduleTodayWidget {
  static Future<void> requestWidgetRefresh() async {
    try {
      WidgetKit.reloadAllTimelines();
    } on PlatformException catch (_) {}
  }
}
