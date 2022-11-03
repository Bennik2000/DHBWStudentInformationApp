import 'package:dhbwstudentapp/native/widget/widget_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';

///
/// WidgetHelper which calls native code to control the widget on iOS
///
class IOSWidgetHelper implements WidgetHelper {
  static const platform = MethodChannel('de.bennik2000.dhbwstudentapp/widget');

  const IOSWidgetHelper();

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

  @override
  Future<bool?> areWidgetsSupported() async {
    try {
      return await platform.invokeMethod('areWidgetsSupported');
    } on PlatformException catch (_) {
      return false;
    }
  }
}
