import 'package:dhbwstudentapp/common/data/database_entity.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';

class ScheduleEntryEntity extends DatabaseEntity {
  ScheduleEntry _scheduleEntry;

  ScheduleEntryEntity.fromModel(ScheduleEntry scheduleEntry) {
    _scheduleEntry = scheduleEntry;
  }

  ScheduleEntryEntity.fromMap(Map<String, dynamic> map) {
    fromMap(map);
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    DateTime startDate;
    if (map["start"] != null) {
      startDate = DateTime.fromMillisecondsSinceEpoch(map["start"]);
    }

    DateTime endDate;
    if (map["end"] != null) {
      endDate = DateTime.fromMillisecondsSinceEpoch(map["end"]);
    }

    _scheduleEntry = ScheduleEntry(
        id: map["id"],
        start: startDate,
        end: endDate,
        details: map["details"],
        professor: map["professor"],
        title: map["title"],
        room: map["room"],
        type: ScheduleEntryType.values[map["type"]]);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": _scheduleEntry.id,
      "start": _scheduleEntry.start?.millisecondsSinceEpoch ?? 0,
      "end": _scheduleEntry.end?.millisecondsSinceEpoch ?? 0,
      "details": _scheduleEntry.details ?? "",
      "professor": _scheduleEntry.professor ?? "",
      "room": _scheduleEntry.room ?? "",
      "title": _scheduleEntry.title ?? "",
      "type": _scheduleEntry.type?.index
    };
  }

  ScheduleEntry asScheduleEntry() => _scheduleEntry;

  static String tableName() => "ScheduleEntries";
}
