import 'dart:io';

import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:dhbwstudentapp/schedule/service/rapla/rapla_response_parser.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var monthlyRaplaPage = await File(Directory.current.absolute.path +
          '/test/schedule/service/rapla/html_resources/rapla_monthly_response.html')
      .readAsString();

  var raplaPage = await File(Directory.current.absolute.path +
          '/test/schedule/service/rapla/html_resources/rapla_response.html')
      .readAsString();

  var severalMonthsPage = await File(Directory.current.absolute.path +
          '/test/schedule/service/rapla/html_resources/rapla_several_months_response.html')
      .readAsString();

  var invalidRaplaPage = await File(Directory.current.absolute.path +
          '/test/schedule/service/rapla/html_resources/invalid_rapla_response.html')
      .readAsString();

  test('Rapla correctly read all classes of weekly view', () async {
    var parser = RaplaResponseParser();

    var schedule = parser.parseSchedule(raplaPage).schedule;

    expect(schedule.entries.length, 8);

    expect(schedule.entries[0].title, "Netztechnik I");
    expect(schedule.entries[0].start, DateTime(2020, 09, 07, 09, 15));
    expect(schedule.entries[0].end, DateTime(2020, 09, 07, 11, 45));
    expect(schedule.entries[0].type, ScheduleEntryType.Class);
    expect(schedule.entries[0].professor, "Müller, Georg");

    expect(schedule.entries[1].title, "Semestereinführung");
    expect(schedule.entries[1].start, DateTime(2020, 09, 07, 12, 00));
    expect(schedule.entries[1].end, DateTime(2020, 09, 07, 12, 30));
    expect(schedule.entries[1].type, ScheduleEntryType.Class);

    expect(schedule.entries[2].title, "Messdatenerfassung");
    expect(schedule.entries[2].start, DateTime(2020, 09, 07, 13, 00));
    expect(schedule.entries[2].end, DateTime(2020, 09, 07, 14, 30));
    expect(schedule.entries[2].type, ScheduleEntryType.Class);

    expect(schedule.entries[3].title, "Formale Sprachen & Automaten");
    expect(schedule.entries[3].start, DateTime(2020, 09, 08, 08, 15));
    expect(schedule.entries[3].end, DateTime(2020, 09, 08, 11, 45));
    expect(schedule.entries[3].type, ScheduleEntryType.Class);

    expect(schedule.entries[4].title, "Signale & Systeme I");
    expect(schedule.entries[4].start, DateTime(2020, 09, 08, 13, 00));
    expect(schedule.entries[4].end, DateTime(2020, 09, 08, 15, 00));
    expect(schedule.entries[4].type, ScheduleEntryType.Class);

    expect(schedule.entries[5].title, "Angewandte Mathematik");
    expect(schedule.entries[5].start, DateTime(2020, 09, 09, 09, 00));
    expect(schedule.entries[5].end, DateTime(2020, 09, 09, 11, 45));
    expect(schedule.entries[5].type, ScheduleEntryType.Class);

    expect(schedule.entries[6].title, "SWE");
    expect(schedule.entries[6].start, DateTime(2020, 09, 10, 09, 15));
    expect(schedule.entries[6].end, DateTime(2020, 09, 10, 12, 00));
    expect(schedule.entries[6].type, ScheduleEntryType.Class);

    expect(schedule.entries[7].title, "Messdatenerfassung");
    expect(schedule.entries[7].start, DateTime(2020, 09, 10, 13, 00));
    expect(schedule.entries[7].end, DateTime(2020, 09, 10, 14, 30));
    expect(schedule.entries[7].type, ScheduleEntryType.Class);
  });

  test('Rapla correctly read all classes of monthly view', () async {
    var parser = RaplaResponseParser();

    var schedule = parser.parseSchedule(monthlyRaplaPage).schedule;

    expect(schedule.entries.length, 9);

    expect(schedule.entries[0].title, "Mikrocontroller ONLINE");
    expect(schedule.entries[0].start, DateTime(2020, 10, 01, 13, 00));
    expect(schedule.entries[0].end, DateTime(2020, 10, 01, 18, 00));
    expect(schedule.entries[0].type, ScheduleEntryType.Class);
    expect(schedule.entries[0].professor, "Schmitt, Tobias");
  });

  test('Rapla correctly read all classes of several months view', () async {
    var parser = RaplaResponseParser();

    var schedule = parser.parseSchedule(severalMonthsPage).schedule;

    expect(schedule.entries[0].title, "Modulprüfung T3_2000");
    expect(schedule.entries[0].start, DateTime(2021, 09, 22, 08, 00));
    expect(schedule.entries[0].end, DateTime(2021, 09, 22, 15, 00));
    expect(schedule.entries[0].type, ScheduleEntryType.Class);
    expect(schedule.entries[0].professor, "A");

    expect(schedule.entries[2].title, "Tag der Deutschen Einheit");
    expect(schedule.entries[2].start, DateTime(2021, 10, 03, 08, 00));
    expect(schedule.entries[2].end, DateTime(2021, 10, 03, 18, 00));
    expect(schedule.entries[2].type, ScheduleEntryType.Unknown);

    expect(schedule.entries[8].title, "Ausgewählte Themen der Informatik");
    expect(schedule.entries[8].start, DateTime(2021, 10, 06, 13, 45));
    expect(schedule.entries[8].end, DateTime(2021, 10, 06, 17, 00));
    expect(schedule.entries[8].type, ScheduleEntryType.Class);

    expect(schedule.entries[84].title, "Silvester");
    expect(schedule.entries[84].start, DateTime(2021, 12, 31, 08, 00));
    expect(schedule.entries[84].end, DateTime(2021, 12, 31, 18, 00));
    expect(schedule.entries[84].type, ScheduleEntryType.Unknown);

    expect(schedule.entries.length, 85);
  });

  test('Rapla robust parse', () async {
    var parser = RaplaResponseParser();

    var result = parser.parseSchedule(invalidRaplaPage);
    var schedule = result.schedule;
    var errors = result.errors;

    expect(errors.length, 4);
    expect(schedule.entries.length, 4);
  });
}
