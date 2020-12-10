import 'package:dhbwstudentapp/native/widget/widget_helper.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_provider.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';

class WidgetUpdateCallback {
  final WidgetHelper _widgetHelper;

  WidgetUpdateCallback(this._widgetHelper);

  void registerCallback(ScheduleProvider provider) {
    provider.addScheduleUpdatedCallback(_callback);
  }

  Future<void> _callback(
    Schedule schedule,
    DateTime start,
    DateTime end,
  ) async {
    await _widgetHelper.requestWidgetRefresh();
  }
}
