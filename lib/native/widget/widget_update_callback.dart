import 'package:dhbwstudentapp/native/widget/widget_helper.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_provider.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';

///
/// This class registers a callback to update the widgets when the schedule
/// was updated
///
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
