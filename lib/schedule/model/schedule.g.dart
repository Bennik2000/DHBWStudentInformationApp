// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ScheduleCWProxy {
  Schedule entries(List<ScheduleEntry> entries);

  Schedule urls(List<String> urls);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Schedule(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Schedule(...).copyWith(id: 12, name: "My name")
  /// ````
  Schedule call({
    List<ScheduleEntry>? entries,
    List<String>? urls,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSchedule.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSchedule.copyWith.fieldName(...)`
class _$ScheduleCWProxyImpl implements _$ScheduleCWProxy {
  final Schedule _value;

  const _$ScheduleCWProxyImpl(this._value);

  @override
  Schedule entries(List<ScheduleEntry> entries) => this(entries: entries);

  @override
  Schedule urls(List<String> urls) => this(urls: urls);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Schedule(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Schedule(...).copyWith(id: 12, name: "My name")
  /// ````
  Schedule call({
    Object? entries = const $CopyWithPlaceholder(),
    Object? urls = const $CopyWithPlaceholder(),
  }) {
    return Schedule(
      entries: entries == const $CopyWithPlaceholder() || entries == null
          ? _value.entries
          // ignore: cast_nullable_to_non_nullable
          : entries as List<ScheduleEntry>,
      urls: urls == const $CopyWithPlaceholder() || urls == null
          ? _value.urls
          // ignore: cast_nullable_to_non_nullable
          : urls as List<String>,
    );
  }
}

extension $ScheduleCopyWith on Schedule {
  /// Returns a callable class that can be used as follows: `instanceOfSchedule.copyWith(...)` or like so:`instanceOfSchedule.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ScheduleCWProxy get copyWith => _$ScheduleCWProxyImpl(this);
}
