// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_entry.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ScheduleEntryCWProxy {
  ScheduleEntry details(String? details);

  ScheduleEntry end(DateTime? end);

  ScheduleEntry id(int? id);

  ScheduleEntry professor(String? professor);

  ScheduleEntry room(String? room);

  ScheduleEntry start(DateTime? start);

  ScheduleEntry title(String? title);

  ScheduleEntry type(ScheduleEntryType type);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ScheduleEntry(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ScheduleEntry(...).copyWith(id: 12, name: "My name")
  /// ````
  ScheduleEntry call({
    String? details,
    DateTime? end,
    int? id,
    String? professor,
    String? room,
    DateTime? start,
    String? title,
    ScheduleEntryType? type,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfScheduleEntry.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfScheduleEntry.copyWith.fieldName(...)`
class _$ScheduleEntryCWProxyImpl implements _$ScheduleEntryCWProxy {
  final ScheduleEntry _value;

  const _$ScheduleEntryCWProxyImpl(this._value);

  @override
  ScheduleEntry details(String? details) => this(details: details);

  @override
  ScheduleEntry end(DateTime? end) => this(end: end);

  @override
  ScheduleEntry id(int? id) => this(id: id);

  @override
  ScheduleEntry professor(String? professor) => this(professor: professor);

  @override
  ScheduleEntry room(String? room) => this(room: room);

  @override
  ScheduleEntry start(DateTime? start) => this(start: start);

  @override
  ScheduleEntry title(String? title) => this(title: title);

  @override
  ScheduleEntry type(ScheduleEntryType type) => this(type: type);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ScheduleEntry(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ScheduleEntry(...).copyWith(id: 12, name: "My name")
  /// ````
  ScheduleEntry call({
    Object? details = const $CopyWithPlaceholder(),
    Object? end = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? professor = const $CopyWithPlaceholder(),
    Object? room = const $CopyWithPlaceholder(),
    Object? start = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
  }) {
    return ScheduleEntry(
      details: details == const $CopyWithPlaceholder()
          ? _value.details
          // ignore: cast_nullable_to_non_nullable
          : details as String?,
      end: end == const $CopyWithPlaceholder()
          ? _value.end
          // ignore: cast_nullable_to_non_nullable
          : end as DateTime?,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      professor: professor == const $CopyWithPlaceholder()
          ? _value.professor
          // ignore: cast_nullable_to_non_nullable
          : professor as String?,
      room: room == const $CopyWithPlaceholder()
          ? _value.room
          // ignore: cast_nullable_to_non_nullable
          : room as String?,
      start: start == const $CopyWithPlaceholder()
          ? _value.start
          // ignore: cast_nullable_to_non_nullable
          : start as DateTime?,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String?,
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as ScheduleEntryType,
    );
  }
}

extension $ScheduleEntryCopyWith on ScheduleEntry {
  /// Returns a callable class that can be used as follows: `instanceOfScheduleEntry.copyWith(...)` or like so:`instanceOfScheduleEntry.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ScheduleEntryCWProxy get copyWith => _$ScheduleEntryCWProxyImpl(this);
}
