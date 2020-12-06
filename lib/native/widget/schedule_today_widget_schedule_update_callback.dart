import 'dart:io';

import 'package:dhbwstudentapp/native/widget/android_schedule_today_widget.dart';
import 'package:dhbwstudentapp/native/widget/ios_schedule_today_widget.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_provider.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';

class ScheduleTodayWidgetScheduleUpdateCallback {
  void registerCallback(ScheduleProvider provider) {
    provider.addScheduleUpdatedCallback(_callback);
  }

  Future<void> _callback(
    Schedule schedule,
    DateTime start,
    DateTime end,
  ) async {
    if (Platform.isIOS) {
      await IOSScheduleTodayWidget.requestWidgetRefresh();
    } else if (Platform.isAndroid) {
      await AndroidScheduleTodayWidget.requestWidgetRefresh();
    }
  }
}
