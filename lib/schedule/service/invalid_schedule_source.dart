import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_result.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';

class InvalidScheduleSource extends ScheduleSource {
  const InvalidScheduleSource();

  @override
  Future<ScheduleQueryResult> querySchedule(
    DateTime? from,
    DateTime? to, [
    CancellationToken? cancellationToken,
  ]) {
    throw StateError("Schedule source not properly configured");
  }

  @override
  bool canQuery() {
    return false;
  }
}
