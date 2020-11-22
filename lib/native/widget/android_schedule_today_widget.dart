import 'package:flutter/services.dart';

class AndroidScheduleTodayWidget {
  static const platform =
      const MethodChannel('de.bennik2000.dhbwstudentapp/widget');

  static Future<void> requestWidgetRefresh() async {
    try {
      await platform.invokeMethod('requestWidgetRefresh');
    } on PlatformException catch (e) {}
  }
}
