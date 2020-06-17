import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';

abstract class ScheduleSource {
  ///
  /// Queries the schedule from the implemented service. The resulting schedule
  /// contains all entries between the `from` and `to` date.
  /// When a `cancellationToken` is provided the operation may be cancelled.
  /// Returns a future which gives the updated schedule or throws an exception
  /// if an error happened or the operation was cancelled
  ///
  Future<Schedule> querySchedule(DateTime from, DateTime to,
      [CancellationToken cancellationToken]);

  void setEndpointUrl(String url);

  void validateEndpointUrl(String url);
}

class ScheduleQueryFailedException implements Exception {
  final dynamic innerException;

  ScheduleQueryFailedException(this.innerException);

  @override
  String toString() {
    return innerException?.toString();
  }
}

class EndpointUrlInvalid implements Exception {}
