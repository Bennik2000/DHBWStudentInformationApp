import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'schedule_entry.g.dart';

enum ScheduleEntryType {
  Unknown,
  Class,
  Online,
  PublicHoliday,
  Exam,
}

@CopyWith()
class ScheduleEntry extends Equatable {
  final int? id;
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

  @override
  List<Object?> get props =>
      [start, end, title, details, professor, room, type];
}
