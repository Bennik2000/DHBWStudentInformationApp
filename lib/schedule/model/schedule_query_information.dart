class ScheduleQueryInformation {
  final DateTime start;
  final DateTime end;
  final DateTime? queryTime;

  ScheduleQueryInformation(
    DateTime? start,
    DateTime? end,
    this.queryTime,
  )   : start = start ?? DateTime.fromMillisecondsSinceEpoch(0),
        end = end ?? DateTime.fromMillisecondsSinceEpoch(0);
}
