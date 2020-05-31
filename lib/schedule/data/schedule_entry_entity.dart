import 'package:dhbwstuttgart/common/data/database_entity.dart';
import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';

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
    var startDate;
    if (map["start"] != null) {
      startDate = DateTime.fromMillisecondsSinceEpoch(map["start"]);
    }

    var endDate;
    if (map["end"] != null) {
      endDate = DateTime.fromMillisecondsSinceEpoch(map["end"]);
    }

    _scheduleEntry = new ScheduleEntry(
      id: map["id"],
      start: startDate,
      end: endDate,
      details: map["details"],
      professor: map["professor"],
      title: map["title"],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": _scheduleEntry.id,
      "start": _scheduleEntry.start?.millisecondsSinceEpoch ?? 0,
      "end": _scheduleEntry.end?.millisecondsSinceEpoch ?? 0,
      "details": _scheduleEntry.details ?? "",
      "professor": _scheduleEntry.professor ?? "",
      "title": _scheduleEntry.title ?? "",
    };
  }

  ScheduleEntry asScheduleEntry() => _scheduleEntry;

  static String tableName() => "ScheduleEntries";
}
