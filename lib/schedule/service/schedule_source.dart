import 'package:dhbwstuttgart/common/util/cancellation_token.dart';
import 'package:dhbwstuttgart/schedule/model/schedule.dart';

abstract class ScheduleSource {
  ///
  /// Queries the schedule from the implemented service. The resulting schedule
  /// contains all entries between the `from` and `to` date.
  /// When a `cancellationToken` is provided the operation may be cancelled.
  /// Returns a future which gives the updated schedule or null if an error
  /// happened or the operation was cancelled
  ///
  Future<Schedule> querySchedule(DateTime from, DateTime to,
      [CancellationToken cancellationToken]);
}
