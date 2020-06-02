import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';
import 'package:flutter/material.dart';

final Map<ScheduleEntryType, Color> scheduleEntryTypeColorMapping = {
  ScheduleEntryType.PublicHoliday: Color(0xffcbcbcb),
  ScheduleEntryType.Class: Color(0xffe6041a),
  ScheduleEntryType.Exam: Color(0xffe6d704),
  ScheduleEntryType.Online: Color(0xffe6041a),
  ScheduleEntryType.Unknown: Color(0xfff6f6f6),
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
