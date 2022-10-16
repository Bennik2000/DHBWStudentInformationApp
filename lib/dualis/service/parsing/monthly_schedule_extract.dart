import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

class MonthlyScheduleExtract {
  const MonthlyScheduleExtract();

  Schedule extractScheduleFromMonthly(String? body) {
    try {
      return _extractScheduleFromMonthly(body);
    } catch (e, trace) {
      if (e.runtimeType is ParseException) rethrow;
      throw ParseException.withInner(e, trace);
    }
  }

  Schedule _extractScheduleFromMonthly(String? body) {
    final document = parse(body);

    final appointments = document.getElementsByClassName("apmntLink");

    final allEntries = <ScheduleEntry>[];

    for (final appointment in appointments) {
      final entry = _extractEntry(appointment);

      allEntries.add(entry);
    }

    allEntries.sort(
      (ScheduleEntry e1, ScheduleEntry e2) => e1.start.compareTo(e2.start),
    );

    return Schedule(entries: allEntries);
  }

  ScheduleEntry _extractEntry(Element appointment) {
    final date = appointment.parent?.parent
        ?.querySelector(".tbsubhead a")
        ?.attributes["title"];

    final information = appointment.attributes["title"]!;
    final informationParts = information.split(" / ");

    final startAndEnd = informationParts[0].split(" - ");
    final start = "$date ${startAndEnd[0]}";
    final end = "$date ${startAndEnd[1]}";
    final room = informationParts[1];
    final title = informationParts[2];

    final dateFormat = DateFormat("dd.MM.yyyy HH:mm");
    final startDate = dateFormat.parse(start);
    final endDate = dateFormat.parse(end);

    final entry = ScheduleEntry(
      title: title,
      professor: "",
      details: "",
      room: room,
      type: ScheduleEntryType.Lesson,
      start: startDate,
      end: endDate,
    );

    return entry;
  }
}
