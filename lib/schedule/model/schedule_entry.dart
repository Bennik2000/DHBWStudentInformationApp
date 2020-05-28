class ScheduleEntry {
  int id;
  final DateTime start;
  final DateTime end;
  final String title;
  final String details;
  final String professor;

  ScheduleEntry({
    this.id,
    this.start,
    this.end,
    this.title,
    this.details,
    this.professor,
  });
}
