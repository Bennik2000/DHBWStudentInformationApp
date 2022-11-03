// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateEntry _$DateEntryFromJson(Map<String, dynamic> json) => DateEntry(
      description: json['description'] as String?,
      year: json['year'] as String?,
      comment: json['comment'] as String?,
      databaseName: json['databaseName'] as String?,
      start: _$JsonConverterFromJson<int, DateTime>(
          json['date'], const EpochDateTimeConverter().fromJson),
      end: _$JsonConverterFromJson<int, DateTime>(
          json['end'], const EpochDateTimeConverter().fromJson),
      room: json['room'] as String?,
    );

Map<String, dynamic> _$DateEntryToJson(DateEntry instance) => <String, dynamic>{
      'description': instance.description,
      'year': instance.year,
      'comment': instance.comment,
      'databaseName': instance.databaseName,
      'date': const EpochDateTimeConverter().toJson(instance.start),
      'end': const EpochDateTimeConverter().toJson(instance.end),
      'room': instance.room,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);
