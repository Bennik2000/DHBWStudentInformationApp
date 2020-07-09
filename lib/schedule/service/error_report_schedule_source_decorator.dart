import 'package:dhbwstudentapp/common/logging/crash_reporting.dart';
import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';

class ErrorReportScheduleSourceDecorator extends ScheduleSource {
  final ScheduleSource _scheduleSource;

  ErrorReportScheduleSourceDecorator(this._scheduleSource);

  @override
  Future<Schedule> querySchedule(DateTime from, DateTime to,
      [CancellationToken cancellationToken]) async {
    try {
      var schedule = await _scheduleSource.querySchedule(
        from,
        to,
        cancellationToken,
      );

      return schedule;
    } catch (ex, trace) {
      if (ex is OperationCancelledException) rethrow;

      await reportException(ex, trace);
      rethrow;
    }
  }

  void setEndpointUrl(String url) => _scheduleSource.setEndpointUrl(url);

  void validateEndpointUrl(String url) =>
      _scheduleSource.validateEndpointUrl(url);
}
