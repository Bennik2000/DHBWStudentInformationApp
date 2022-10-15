// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_query_information.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleQueryInformation _$ScheduleQueryInformationFromJson(
        Map<String, dynamic> json) =>
    ScheduleQueryInformation(
      _$JsonConverterFromJson<int, DateTime>(
          json['start'], const EpochDateTimeConverter().fromJson),
      _$JsonConverterFromJson<int, DateTime>(
          json['end'], const EpochDateTimeConverter().fromJson),
      _$JsonConverterFromJson<int, DateTime>(
          json['queryTime'], const EpochDateTimeConverter().fromJson),
    );

Map<String, dynamic> _$ScheduleQueryInformationToJson(
        ScheduleQueryInformation instance) =>
    <String, dynamic>{
      'start': const EpochDateTimeConverter().toJson(instance.start),
      'end': const EpochDateTimeConverter().toJson(instance.end),
      'queryTime': _$JsonConverterToJson<int, DateTime>(
          instance.queryTime, const EpochDateTimeConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
