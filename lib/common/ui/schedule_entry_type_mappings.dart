import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:flutter/material.dart';

typedef ColorDelegate = Color Function(BuildContext context);
typedef TextDelegate = String Function(BuildContext context);

final Map<ScheduleEntryType, TextDelegate> scheduleEntryTypeTextMapping = {
  ScheduleEntryType.PublicHoliday: (c) =>
      L.of(c).scheduleEntryTypePublicHoliday,
  ScheduleEntryType.Lesson: (c) => L.of(c).scheduleEntryTypeClass,
  ScheduleEntryType.Exam: (c) => L.of(c).scheduleEntryTypeExam,
  ScheduleEntryType.Online: (c) => L.of(c).scheduleEntryTypeOnline,
  ScheduleEntryType.Unknown: (c) => L.of(c).scheduleEntryTypeUnknown,
};

String scheduleEntryTypeToReadableString(
  BuildContext context,
  ScheduleEntryType type,
) {
  return scheduleEntryTypeTextMapping[type]!(context);
}
