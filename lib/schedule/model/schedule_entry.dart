enum ScheduleEntryType {
  Unknown,
  Class,
  Online,
  PublicHoliday,
  Exam,
}

class ScheduleEntry {
  int? id;
  final DateTime start;
  final DateTime end;
  final String title;
  final String details;
  final String professor;
  final String room;
  final ScheduleEntryType type;

  ScheduleEntry({
    this.id,
    DateTime? start,
    DateTime? end,
    String? title,
    String? details,
    String? professor,
    String? room,
    required this.type,
  })  : start = start ?? DateTime.fromMicrosecondsSinceEpoch(0),
        end = end ?? DateTime.fromMicrosecondsSinceEpoch(0),
        details = details ?? "",
        professor = professor ?? "",
        room = room ?? "",
        title = title ?? "";

  bool equalsWithIdIgnored(ScheduleEntry other) {
    return start == other.start &&
        end == other.end &&
        title == other.title &&
        details == other.details &&
        professor == other.professor &&
        room == other.room &&
        type == other.type;
  }

  List<String> getDifferentProperties(ScheduleEntry entry) {
    final changedProperties = <String>[];

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

  // TODO: [Leptopoda] use buildrunner
  ScheduleEntry copyWith(
      {DateTime? start,
      DateTime? end,
      String? title,
      String? details,
      String? professor,
      String? room,
      ScheduleEntryType? type,}) {
    return ScheduleEntry(
      id: id,
      start: start ?? this.start,
      end: end ?? this.end,
      title: title ?? this.title,
      details: details ?? this.details,
      professor: professor ?? this.professor,
      room: room ?? this.room,
      type: type ?? this.type,
    );
  }
}
