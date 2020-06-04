import 'package:dhbwstuttgart/common/ui/colors.dart';
import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';
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
  ScheduleEntryType.PublicHoliday: (c) => "Feiertag",
  ScheduleEntryType.Class: (c) => "Vorlesung",
  ScheduleEntryType.Exam: (c) => "Klausur / Prüfung",
  ScheduleEntryType.Online: (c) => "Online Vorlesung",
  ScheduleEntryType.Unknown: (c) => "",
};

Color scheduleEntryTypeToColor(
  BuildContext context,
  ScheduleEntryType type,
) {
  return scheduleEntryTypeColorMapping[type](context);
}

String scheduleEntryTypeToReadableString(
  BuildContext context,
  ScheduleEntryType type,
) {
  return scheduleEntryTypeTextMapping[type](context);
}
