import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_result.dart';

abstract class ScheduleSource {
  const ScheduleSource();

  ///
  /// Queries the schedule from the implemented service. The resulting schedule
  /// contains all entries between the `from` and `to` date.
  /// When a `cancellationToken` is provided the operation may be cancelled.
  /// Returns a future which gives the updated schedule or throws an exception
  /// if an error happened or the operation was cancelled
  ///
  Future<ScheduleQueryResult?> querySchedule(
    DateTime? from,
    DateTime? to, [
    CancellationToken? cancellationToken,
  ]);

  bool canQuery();
}

class ScheduleQueryFailedException implements Exception {
  final dynamic innerException;
  final StackTrace? trace;

  const ScheduleQueryFailedException(this.innerException, [this.trace]);

  @override
  String toString() {
    return "${innerException.toString()}\n${trace?.toString() ?? ""}";
  }
}

class ServiceRequestFailed implements Exception {
  final String message;

  const ServiceRequestFailed(this.message);

  @override
  String toString() {
    return message;
  }
}

class EndpointUrlInvalid implements Exception {}
