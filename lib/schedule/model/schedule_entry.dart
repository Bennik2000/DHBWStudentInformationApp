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

  List<String> getDifferentProperties(ScheduleEntry entry) {
    var changedProperties = <String>[];

    if (title != entry.title) {
      changedProperties.add("title");
    }
    if (start != entry.start) {
      changedProperties.add("start");
    }
    if (end != entry.end) {
      changedProperties.add("end");
    }
    if (details != entry.details) {
      changedProperties.add("details");
    }
    if (professor != entry.professor) {
      changedProperties.add("professor");
    }
    if (room != entry.room) {
      changedProperties.add("room");
    }
    if (type != entry.type) {
      changedProperties.add("type");
    }

    return changedProperties;
  }
}
