import 'package:dhbwstudentapp/schedule/model/schedule.dart';

class ScheduleQueryResult {
  final Schedule schedule;
  final List<ParseError> errors;

  bool get hasError => errors?.isNotEmpty ?? false;

  ScheduleQueryResult(this.schedule, this.errors);
}

class ParseError {
  final String object;
  final String trace;

  ParseError(Object object, StackTrace trace)
      : object = object?.toString(),
        trace = trace?.toString();
}
