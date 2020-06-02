import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';
import 'package:flutter/material.dart';

final Map<ScheduleEntryType, Color> scheduleEntryTypeColorMapping = {
  ScheduleEntryType.PublicHoliday: Colors.blueGrey,
  ScheduleEntryType.Class: Colors.green,
  ScheduleEntryType.Exam: Colors.red,
  ScheduleEntryType.Online: Colors.lime,
  ScheduleEntryType.Unknown: Colors.grey,
};

final Map<ScheduleEntryType, String> scheduleEntryTypeTextMapping = {
  ScheduleEntryType.PublicHoliday: "Feiertag",
  ScheduleEntryType.Class: "Vorlesung",
  ScheduleEntryType.Exam: "Klausur / Prüfung",
  ScheduleEntryType.Online: "Online Vorlesung",
  ScheduleEntryType.Unknown: "",
};

Color scheduleEntryTypeToColor(ScheduleEntryType type) {
  return scheduleEntryTypeColorMapping[type];
}

String scheduleEntryTypeToReadableString(ScheduleEntryType type) {
  return scheduleEntryTypeTextMapping[type];
}
