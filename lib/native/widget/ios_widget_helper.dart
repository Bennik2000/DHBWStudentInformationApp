import 'package:dhbwstudentapp/native/widget/widget_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';

class IOSWidgetHelper implements WidgetHelper {
  static const platform =
      const MethodChannel('de.bennik2000.dhbwstudentapp/widget');

  @override
  Future<void> disableWidget() async {
    try {
      await platform.invokeMethod('disableWidget');
    } on PlatformException catch (_) {}
  }

  @override
  Future<void> enableWidget() async {
    try {
      await platform.invokeMethod('enableWidget');
    } on PlatformException catch (_) {}
  }

  @override
  Future<void> requestWidgetRefresh() async {
    try {
      // TODO: Use own implementation to get rid of the WidgetKit package
      WidgetKit.reloadAllTimelines();
    } on PlatformException catch (_) {}
  }
}