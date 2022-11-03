import 'package:dhbwstudentapp/common/data/epoch_date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'schedule_query_information.g.dart';

@JsonSerializable()
class ScheduleQueryInformation {
  @EpochDateTimeConverter()
  final DateTime start;
  @EpochDateTimeConverter()
  final DateTime end;
  @EpochDateTimeConverter()
  final DateTime? queryTime;

  ScheduleQueryInformation(
    DateTime? start,
    DateTime? end,
    this.queryTime,
  )   : start = start ?? DateTime.fromMillisecondsSinceEpoch(0),
        end = end ?? DateTime.fromMillisecondsSinceEpoch(0);

  factory ScheduleQueryInformation.fromJson(Map<String, dynamic> json) =>
      _$ScheduleQueryInformationFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleQueryInformationToJson(this);

  static const tableName = "ScheduleQueryInformation";
}
