import 'package:dhbwstudentapp/native/widget/widget_helper.dart';
import 'package:flutter/services.dart';

class AndroidWidgetHelper implements WidgetHelper {
  static const platform =
      const MethodChannel('de.bennik2000.dhbwstudentapp/widget');

  @override
  Future<void> disableWidget() async {}

  @override
  Future<void> enableWidget() async {}

  @override
  Future<void> requestWidgetRefresh() async {
    try {
      await platform.invokeMethod('requestWidgetRefresh');
    } on PlatformException catch (e) {}
  }
}
