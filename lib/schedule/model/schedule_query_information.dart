class ScheduleQueryInformation {
  final DateTime start;
  final DateTime end;
  final DateTime? queryTime;

  ScheduleQueryInformation(
    DateTime? start,
    DateTime? end,
    this.queryTime,
  )   : this.start = start ?? DateTime.fromMillisecondsSinceEpoch(0),
        this.end = end ?? DateTime.fromMillisecondsSinceEpoch(0);
}
