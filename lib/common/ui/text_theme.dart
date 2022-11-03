import 'package:flutter/material.dart';

@immutable
class CustomTextTheme extends ThemeExtension<CustomTextTheme> {
  const CustomTextTheme({
    required this.dailyScheduleEntryType,
    required this.dailyScheduleEntryTimeStart,
    required this.scheduleEntryWidgetTitle,
    required this.scheduleEntryBottomPageType,
    required this.scheduleWidgetColumnTitleDay,
  });

  final TextStyle dailyScheduleEntryType;
  final TextStyle dailyScheduleEntryTimeStart;
  final TextStyle scheduleEntryWidgetTitle;
  final TextStyle scheduleEntryBottomPageType;
  final TextStyle scheduleWidgetColumnTitleDay;

  @override
  CustomTextTheme copyWith({
    TextStyle? dailyScheduleEntryType,
    TextStyle? dailyScheduleEntryTimeStart,
    TextStyle? scheduleEntryWidgetTitle,
    TextStyle? scheduleEntryBottomPageType,
    TextStyle? scheduleWidgetColumnTitleDay,
  }) {
    return CustomTextTheme(
      dailyScheduleEntryType:
          dailyScheduleEntryType ?? this.dailyScheduleEntryType,
      dailyScheduleEntryTimeStart:
          dailyScheduleEntryTimeStart ?? this.dailyScheduleEntryTimeStart,
      scheduleEntryWidgetTitle:
          scheduleEntryWidgetTitle ?? this.scheduleEntryWidgetTitle,
      scheduleEntryBottomPageType:
          scheduleEntryBottomPageType ?? this.scheduleEntryBottomPageType,
      scheduleWidgetColumnTitleDay:
          scheduleWidgetColumnTitleDay ?? this.scheduleWidgetColumnTitleDay,
    );
  }

  @override
  CustomTextTheme lerp(ThemeExtension<CustomTextTheme>? other, double t) {
    if (other is! CustomTextTheme) {
      return this;
    }
    return copyWith(
      dailyScheduleEntryType: TextStyle.lerp(
        dailyScheduleEntryType,
        other.dailyScheduleEntryType,
        t,
      ),
      dailyScheduleEntryTimeStart: TextStyle.lerp(
        dailyScheduleEntryTimeStart,
        other.dailyScheduleEntryTimeStart,
        t,
      ),
      scheduleEntryWidgetTitle: TextStyle.lerp(
        scheduleEntryWidgetTitle,
        other.scheduleEntryWidgetTitle,
        t,
      ),
      scheduleEntryBottomPageType: TextStyle.lerp(
        scheduleEntryBottomPageType,
        other.scheduleEntryBottomPageType,
        t,
      ),
      scheduleWidgetColumnTitleDay: TextStyle.lerp(
        scheduleWidgetColumnTitleDay,
        other.scheduleWidgetColumnTitleDay,
        t,
      ),
    );
  }
}
