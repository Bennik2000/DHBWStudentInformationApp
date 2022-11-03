import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/colors.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:flutter/material.dart';

typedef ColorDelegate = Color Function(BuildContext context);
typedef TextDelegate = String Function(BuildContext context);

final Map<ScheduleEntryType, ColorDelegate> scheduleEntryTypeColorMapping = {
  ScheduleEntryType.PublicHoliday: colorScheduleEntryPublicHoliday,
  ScheduleEntryType.Class: colorScheduleEntryClass,
  ScheduleEntryType.Exam: colorScheduleEntryExam,
  ScheduleEntryType.Online: colorScheduleEntryOnline,
  ScheduleEntryType.Unknown: colorScheduleEntryUnknown,
};

final Map<ScheduleEntryType, TextDelegate> scheduleEntryTypeTextMapping = {
  ScheduleEntryType.PublicHoliday: (c) =>
      L.of(c).scheduleEntryTypePublicHoliday,
  ScheduleEntryType.Class: (c) => L.of(c).scheduleEntryTypeClass,
  ScheduleEntryType.Exam: (c) => L.of(c).scheduleEntryTypeExam,
  ScheduleEntryType.Online: (c) => L.of(c).scheduleEntryTypeOnline,
  ScheduleEntryType.Unknown: (c) => L.of(c).scheduleEntryTypeUnknown,
};

Color scheduleEntryTypeToColor(
  BuildContext context,
  ScheduleEntryType? type,
) {
  return scheduleEntryTypeColorMapping[type!]!(context);
}

String scheduleEntryTypeToReadableString(
  BuildContext context,
  ScheduleEntryType? type,
) {
  return scheduleEntryTypeTextMapping[type!]!(context);
}
