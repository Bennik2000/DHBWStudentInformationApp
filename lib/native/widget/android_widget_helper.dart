import 'package:dhbwstudentapp/native/widget/widget_helper.dart';
import 'package:flutter/services.dart';

///
/// WidgetHelper which calls native code to control the widget on android
///
class AndroidWidgetHelper implements WidgetHelper {
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
      await platform.invokeMethod('requestWidgetRefresh');
    } on PlatformException catch (e) {}
  }

  @override
  Future<bool> areWidgetsSupported() async {
    try {
      return await platform.invokeMethod('areWidgetsSupported');
    } on Exception catch (_) {
      return false;
    }
  }
}
