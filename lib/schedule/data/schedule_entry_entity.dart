import 'package:dhbwstudentapp/common/data/database_entity.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';

class ScheduleEntryEntity extends DatabaseEntity {
  late ScheduleEntry _scheduleEntry;

  ScheduleEntryEntity.fromModel(ScheduleEntry scheduleEntry) {
    _scheduleEntry = scheduleEntry;
  }

  ScheduleEntryEntity.fromMap(Map<String, dynamic> map) {
    fromMap(map);
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    final start = map["start"] as int?;
    DateTime? startDate;
    if (start != null) {
      startDate = DateTime.fromMillisecondsSinceEpoch(start);
    }

    final end = map["end"] as int?;
    DateTime? endDate;
    if (end != null) {
      endDate = DateTime.fromMillisecondsSinceEpoch(end);
    }

    _scheduleEntry = ScheduleEntry(
      id: map["id"] as int?,
      start: startDate,
      end: endDate,
      details: map["details"] as String?,
      professor: map["professor"] as String?,
      title: map["title"] as String?,
      room: map["room"] as String?,
      type: ScheduleEntryType.values[map["type"] as int],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": _scheduleEntry.id,
      "start": _scheduleEntry.start.millisecondsSinceEpoch,
      "end": _scheduleEntry.end.millisecondsSinceEpoch,
      "details": _scheduleEntry.details,
      "professor": _scheduleEntry.professor,
      "room": _scheduleEntry.room,
      "title": _scheduleEntry.title,
      "type": _scheduleEntry.type.index
    };
  }

  ScheduleEntry asScheduleEntry() => _scheduleEntry;

  static String tableName() => "ScheduleEntries";
}
