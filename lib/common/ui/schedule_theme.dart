import 'package:flutter/material.dart';

@immutable
class ScheduleTheme extends ThemeExtension<ScheduleTheme> {
  const ScheduleTheme({
    required this.scheduleGridGridLines,
    required this.scheduleInPastOverlay,
    required this.currentTimeIndicator,
  });

  final Color scheduleGridGridLines;
  final Color scheduleInPastOverlay;
  final Color currentTimeIndicator;

  @override
  ScheduleTheme copyWith({
    Color? scheduleGridGridLines,
    Color? scheduleInPastOverlay,
    Color? currentTimeIndicator,
  }) {
    return ScheduleTheme(
      scheduleGridGridLines:
          scheduleGridGridLines ?? this.scheduleGridGridLines,
      scheduleInPastOverlay:
          scheduleInPastOverlay ?? this.scheduleInPastOverlay,
      currentTimeIndicator: currentTimeIndicator ?? this.currentTimeIndicator,
    );
  }

  @override
  ScheduleTheme lerp(ThemeExtension<ScheduleTheme>? other, double t) {
    if (other is! ScheduleTheme) {
      return this;
    }
    return copyWith(
      scheduleGridGridLines:
          Color.lerp(scheduleGridGridLines, other.scheduleGridGridLines, t),
      scheduleInPastOverlay:
          Color.lerp(scheduleInPastOverlay, other.scheduleInPastOverlay, t),
      currentTimeIndicator:
          Color.lerp(currentTimeIndicator, other.currentTimeIndicator, t),
    );
  }
}
