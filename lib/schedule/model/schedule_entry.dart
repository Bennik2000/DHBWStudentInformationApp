enum ScheduleEntryType {
  Unknown,
  Class,
  Online,
  PublicHoliday,
  Exam,
}

class ScheduleEntry {
  int id;
  final DateTime start;
  final DateTime end;
  final String title;
  final String details;
  final String professor;
  final String room;
  final ScheduleEntryType type;

  ScheduleEntry({
    this.id,
    this.start,
    this.end,
    this.title,
    this.details,
    this.professor,
    this.room,
    this.type,
  });
}
