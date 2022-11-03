import 'package:flutter/material.dart';

@immutable
class ScheduleEntryTheme extends ThemeExtension<ScheduleEntryTheme> {
  const ScheduleEntryTheme({
    required this.unknown,
    required this.lesson,
    required this.online,
    required this.publicHoliday,
    required this.exam,
  });

  final Color unknown;
  final Color lesson;
  final Color online;
  final Color publicHoliday;
  final Color exam;

  @override
  ScheduleEntryTheme copyWith({
    Color? unknown,
    Color? lesson,
    Color? online,
    Color? publicHoliday,
    Color? exam,
  }) {
    return ScheduleEntryTheme(
      unknown: unknown ?? this.unknown,
      lesson: lesson ?? this.lesson,
      online: online ?? this.online,
      publicHoliday: publicHoliday ?? this.publicHoliday,
      exam: exam ?? this.exam,
    );
  }

  @override
  ScheduleEntryTheme lerp(ThemeExtension<ScheduleEntryTheme>? other, double t) {
    if (other is! ScheduleEntryTheme) {
      return this;
    }
    return copyWith(
      unknown: Color.lerp(unknown, other.unknown, t),
      lesson: Color.lerp(lesson, other.lesson, t),
      online: Color.lerp(online, other.online, t),
      publicHoliday: Color.lerp(publicHoliday, other.publicHoliday, t),
      exam: Color.lerp(exam, other.exam, t),
    );
  }
}
