import 'dart:io';

import 'package:dhbwstudentapp/native/widget/android_widget_helper.dart';
import 'package:dhbwstudentapp/native/widget/ios_widget_helper.dart';

///
/// Flutter part of the native widgets. This class calls the native platform
/// methods to enable/disable or update the widget
///
class WidgetHelper {
  static WidgetHelper? _instance;

  WidgetHelper() {
    if (_instance != null) return;

    if (Platform.isAndroid) {
      _instance = AndroidWidgetHelper();
    } else if (Platform.isIOS) {
      _instance = IOSWidgetHelper();
    } else {
      _instance = VoidWidgetHelper();
    }
  }

  ///
  /// Updates the widgets. This may not be immediateley but an update is
  /// scheduled and will happen soon.
  ///
  Future<void> requestWidgetRefresh() {
    return _instance!.requestWidgetRefresh();
  }

  ///
  /// Checks if widgets are supported by the device
  ///
  Future<bool?> areWidgetsSupported() {
    return _instance!.areWidgetsSupported();
  }

  ///
  /// Enables the widget. When the widget is in "enabled" state it will provide
  /// its full functionality.
  ///
  Future<void> enableWidget() {
    return _instance!.enableWidget();
  }

  ///
  /// Disables the widget. When the widget is in "disabled" state it will
  /// only provide placeholder content or limited functionality.
  ///
  Future<void> disableWidget() {
    return _instance!.disableWidget();
  }
}

///
/// Implementation of the WidgetHelper which does nothing
///
class VoidWidgetHelper implements WidgetHelper {
  @override
  Future<void> disableWidget() {
    return Future.value();
  }

  @override
  Future<void> enableWidget() {
    return Future.value();
  }

  @override
  Future<void> requestWidgetRefresh() {
    return Future.value();
  }

  @override
  Future<bool> areWidgetsSupported() {
    return Future.value(false);
  }
}
