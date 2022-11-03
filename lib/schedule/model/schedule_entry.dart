import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dhbwstudentapp/common/data/epoch_date_time_converter.dart';
import 'package:dhbwstudentapp/common/ui/schedule_entry_theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'schedule_entry.g.dart';

enum ScheduleEntryType {
  Unknown,
  Lesson,
  Online,
  PublicHoliday,
  Exam;

  Color color(BuildContext context) {
    final scheduleEntryTheme =
        Theme.of(context).extension<ScheduleEntryTheme>()!;

    switch (this) {
      case ScheduleEntryType.PublicHoliday:
        return scheduleEntryTheme.publicHoliday;
      case ScheduleEntryType.Lesson:
        return scheduleEntryTheme.lesson;
      case ScheduleEntryType.Exam:
        return scheduleEntryTheme.exam;
      case ScheduleEntryType.Online:
        return scheduleEntryTheme.online;
      case ScheduleEntryType.Unknown:
        return scheduleEntryTheme.unknown;
    }
  }
}

@CopyWith()
@JsonSerializable()
class ScheduleEntry extends Equatable {
  final int? id;
  @EpochDateTimeConverter()
  final DateTime start;
  @EpochDateTimeConverter()
  final DateTime end;
  final String title;
  final String details;
  final String professor;
  final String room;
  @JsonKey(
    toJson: _typeToJson,
    fromJson: _typeFromJson,
  )
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

  factory ScheduleEntry.fromJson(Map<String, dynamic> json) =>
      _$ScheduleEntryFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleEntryToJson(this);

  static const tableName = "ScheduleEntries";

  static int _typeToJson(ScheduleEntryType value) => value.index;
  static ScheduleEntryType _typeFromJson(int value) =>
      ScheduleEntryType.values[value];

  @override
  List<Object?> get props =>
      [start, end, title, details, professor, room, type];
}
