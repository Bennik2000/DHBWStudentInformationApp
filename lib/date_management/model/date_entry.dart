import 'package:dhbwstudentapp/common/data/epoch_date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'date_entry.g.dart';

@JsonSerializable()
class DateEntry {
  final String description;
  final String year;
  final String comment;
  final String databaseName;
  @JsonKey(name: "date")
  @EpochDateTimeConverter()
  final DateTime start;
  @EpochDateTimeConverter()
  final DateTime end;
  final String? room;

  DateEntry({
    String? description,
    String? year,
    String? comment,
    String? databaseName,
    DateTime? start,
    DateTime? end,
    this.room,
  })  : start = start ?? DateTime.fromMicrosecondsSinceEpoch(0),
        end = end ?? start ?? DateTime.fromMicrosecondsSinceEpoch(0),
        comment = comment ?? "",
        description = description ?? "",
        year = year ?? "",
        databaseName = databaseName ?? "";

  factory DateEntry.fromJson(Map<String, dynamic> json) =>
      _$DateEntryFromJson(json);

  Map<String, dynamic> toJson() => _$DateEntryToJson(this);

  static const tableName = "DateEntries";
}
