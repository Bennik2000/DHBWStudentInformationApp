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

  var raplaPage1 = await File(Directory.current.absolute.path +
          '/test/schedule/service/rapla/html_resources/rapla_response_1.html')
      .readAsString();

  var severalMonthsPage = await File(Directory.current.absolute.path +
          '/test/schedule/service/rapla/html_resources/rapla_several_months_response.html')
      .readAsString();

  var severalMonthsPage1 = await File(Directory.current.absolute.path +
          '/test/schedule/service/rapla/html_resources/rapla_several_months_response_1.html')
      .readAsString();

  var severalMonthsPage2 = await File(Directory.current.absolute.path +
          '/test/schedule/service/rapla/html_resources/rapla_several_months_response_2.html')
      .readAsString();

  var invalidRaplaPage = await File(Directory.current.absolute.path +
          '/test/schedule/service/rapla/html_resources/invalid_rapla_response.html')
      .readAsString();

  var raplaWeekResponse = await File(Directory.current.absolute.path +
          '/test/schedule/service/rapla/html_resources/rapla_week_response.html')
      .readAsString();

  var raplaWeekResponse1 = await File(Directory.current.absolute.path +
          '/test/schedule/service/rapla/html_resources/rapla_week_response_1.html')
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
    expect(schedule.entries[0].room,
        "MOS-TINF19A,A 1.380 Vorlesungsraum (Mi 22.09.21  08:00, Do 23.09.21  08:00),A 1.390 Vorlesungsraum (Mi 22.09.21  08:00, Do 23.09.21  08:00)");

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

  test('Rapla correctly read all classes of problematic several months view',
      () async {
    var parser = RaplaResponseParser();

    var schedule = parser.parseSchedule(severalMonthsPage1).schedule;

    expect(schedule.entries[0].title, "Verkehrswegebau und Straßenwesen");
    expect(schedule.entries[0].start, DateTime(2021, 12, 01, 08, 15));
    expect(schedule.entries[0].end, DateTime(2021, 12, 01, 12, 15));
    expect(schedule.entries[0].type, ScheduleEntryType.Class);
    expect(schedule.entries[0].professor, "Müller");

    expect(schedule.entries[3].title, "Marketing und Unternehmensstrategie");
    expect(schedule.entries[3].start, DateTime(2021, 12, 03, 13, 00));
    expect(schedule.entries[3].end, DateTime(2021, 12, 03, 16, 15));
    expect(schedule.entries[3].type, ScheduleEntryType.Class);
    expect(schedule.entries[3].professor, "Mayer");

    expect(schedule.entries[11].title, "Stahlbetonbau");
    expect(schedule.entries[11].start, DateTime(2021, 12, 17, 09, 00));
    expect(schedule.entries[11].end, DateTime(2021, 12, 17, 10, 30));
    expect(schedule.entries[11].type, ScheduleEntryType.Exam);

    expect(schedule.entries[17].title, "Silvester");
    expect(schedule.entries[17].start, DateTime(2021, 12, 31, 08, 00));
    expect(schedule.entries[17].end, DateTime(2021, 12, 31, 18, 00));
    expect(schedule.entries[17].type, ScheduleEntryType.Unknown);

    expect(schedule.entries.length, 20);
  });

  test('Rapla correctly read all classes of several months view 3', () async {
    var parser = RaplaResponseParser();

    var schedule = parser.parseSchedule(severalMonthsPage2).schedule;

    expect(schedule.entries[0].title, "Marketing und Unternehmensstrategie");
    expect(schedule.entries[0].start, DateTime(2021, 12, 01, 10, 00));
    expect(schedule.entries[0].end, DateTime(2021, 12, 01, 13, 30));
    expect(schedule.entries[0].type, ScheduleEntryType.Unknown);

    expect(schedule.entries.length, 36);
  });

  test('Rapla correctly read the day of a class in week view', () async {
    var parser = RaplaResponseParser();

    var schedule = parser.parseSchedule(raplaPage1).schedule;

    expect(schedule.entries[0].title, "Grundlagen der Handelsbetriebslehre");
    expect(schedule.entries[0].start, DateTime(2021, 11, 02, 09, 00));
    expect(schedule.entries[0].end, DateTime(2021, 11, 02, 12, 15));
    expect(schedule.entries[0].type, ScheduleEntryType.Class);
    expect(schedule.entries[0].professor, "Fr, Ta");
    expect(schedule.entries[0].room,
        "WDCM21B,G086 W Hörsaal (Di 26.10.21  13:00, Do 04.11.21  12:45, Di 16.11.21  10:00),A167 W Hörsaal (Di 30.11.21  10:00),F218_1 PA Hörsaal (Di 07.12.21  10:00, Mi 08.12.21  13:00),XOnline-Veranstaltung A Virtueller Raum (Di 02.11.21  09:00, Do 11.11.21  09:00)");

    expect(schedule.entries[1].title,
        "Einführung in die Volkswirtschaftslehre und Mikroökonomik");
    expect(schedule.entries[1].start, DateTime(2021, 11, 02, 13, 45));
    expect(schedule.entries[1].end, DateTime(2021, 11, 02, 17, 00));
    expect(schedule.entries[1].type, ScheduleEntryType.Class);
    expect(schedule.entries[1].professor, "Le, An");
    expect(schedule.entries[1].room,
        "WDCM21B,D221 W Hörsaal (Mo 11.10.21  09:00),G086 W Hörsaal (Mo 25.10.21  09:00, Mo 15.11.21  09:00),F218_1 PA Hörsaal (Mo 22.11.21  09:00, Mo 06.12.21  09:00),A167 W Hörsaal (Mo 29.11.21  09:00),XOnline-Veranstaltung A Virtueller Raum (Di 02.11.21  13:45)");

    expect(schedule.entries[2].title, "Grundlagen des Bürgerlichen Rechts");
    expect(schedule.entries[2].start, DateTime(2021, 11, 03, 09, 00));
    expect(schedule.entries[2].end, DateTime(2021, 11, 03, 11, 30));
    expect(schedule.entries[2].type, ScheduleEntryType.Class);
    expect(schedule.entries[2].professor, "Ei, An");
    expect(schedule.entries[2].room,
        "WDCM21B,XOnline-Veranstaltung A Virtueller Raum (Mi 13.10.21  09:00, Mi 27.10.21  09:00, Mi 10.11.21  09:00, Mi 24.11.21  09:00, Fr 03.12.21  10:00),D221 W Hörsaal (Mi 20.10.21  13:00, Mi 17.11.21  09:00),G086 W Hörsaal (Di 26.10.21  09:00, Mi 03.11.21  09:00),B354 W Hörsaal (Fr 03.12.21  10:00),F218_1 PA Hörsaal (Mi 08.12.21  09:00)");

    expect(schedule.entries[3].title, "Technik der Finanzbuchführung I");
    expect(schedule.entries[3].start, DateTime(2021, 11, 03, 13, 00));
    expect(schedule.entries[3].end, DateTime(2021, 11, 03, 16, 15));
    expect(schedule.entries[3].type, ScheduleEntryType.Class);
    expect(schedule.entries[3].professor, "Se, Ka");
    expect(schedule.entries[3].room,
        "WDCM21B,D221 W Hörsaal (Mi 17.11.21  13:00, Mi 06.10.21  13:00, Mi 13.10.21  13:00),G086 W Hörsaal (Mi 27.10.21  13:00, Mi 03.11.21  13:00, Mi 10.11.21  13:00),A167 W Hörsaal (Mi 24.11.21  13:00, Mi 01.12.21  14:00)");

    expect(schedule.entries[4].title,
        "Grundlagen des wissenschaftlichen Arbeitens");
    expect(schedule.entries[4].start, DateTime(2021, 11, 04, 09, 00));
    expect(schedule.entries[4].end, DateTime(2021, 11, 04, 12, 15));
    expect(schedule.entries[4].type, ScheduleEntryType.Class);
    expect(schedule.entries[4].professor, "He, Be");
    expect(schedule.entries[4].room,
        "WDCM21B,D221 W Hörsaal (Di 05.10.21  09:00, Di 12.10.21  09:00),A167 W Hörsaal (Di 23.11.21  09:00),G086 W Hörsaal (Do 04.11.21  09:00)");

    expect(schedule.entries[5].title, "Grundlagen der Handelsbetriebslehre");
    expect(schedule.entries[5].start, DateTime(2021, 11, 04, 12, 45));
    expect(schedule.entries[5].end, DateTime(2021, 11, 04, 16, 00));
    expect(schedule.entries[5].type, ScheduleEntryType.Class);
    expect(schedule.entries[5].professor, "Fr, Ta");
    expect(schedule.entries[5].room,
        "WDCM21B,G086 W Hörsaal (Di 26.10.21  13:00, Do 04.11.21  12:45, Di 16.11.21  10:00),A167 W Hörsaal (Di 30.11.21  10:00),F218_1 PA Hörsaal (Di 07.12.21  10:00, Mi 08.12.21  13:00),XOnline-Veranstaltung A Virtueller Raum (Di 02.11.21  09:00, Do 11.11.21  09:00)");

    expect(schedule.entries[6].title, "Einführung in die Programmierung");
    expect(schedule.entries[6].start, DateTime(2021, 11, 05, 13, 00));
    expect(schedule.entries[6].end, DateTime(2021, 11, 05, 16, 15));
    expect(schedule.entries[6].type, ScheduleEntryType.Class);
    expect(schedule.entries[6].professor, "He, Ma");
    expect(schedule.entries[6].room,
        "WDCM21B,C348  PC Raum,D221 W Hörsaal (Fr 08.10.21  13:00, Fr 15.10.21  13:00, Fr 22.10.21  13:00),G086 W Hörsaal (Fr 29.10.21  13:00, Fr 05.11.21  13:00, Fr 12.11.21  13:00, Do 18.11.21  13:00),A167 W Hörsaal (Fr 26.11.21  13:00, Do 02.12.21  13:00)");

    expect(schedule.entries.length, 7);
  });

  test('Rapla correctly read the week response', () async {
    var parser = RaplaResponseParser();

    var schedule = parser.parseSchedule(raplaWeekResponse).schedule;

    expect(schedule.entries[0].title, "Geschäftsprozesse, T3ELG1010");
    expect(schedule.entries[0].start, DateTime(2022, 02, 21, 08, 30));
    expect(schedule.entries[0].end, DateTime(2022, 02, 21, 12, 30));
    expect(schedule.entries[0].type, ScheduleEntryType.Online);
    expect(schedule.entries[0].professor, "Ko, Ha, Dipl-.Wirtsch.-Ing.");
    expect(schedule.entries[0].room, "STG-TEL21");

    expect(schedule.entries.length, 6);
  });

  test('Rapla correctly read the week response 1', () async {
    var parser = RaplaResponseParser();

    var schedule = parser.parseSchedule(raplaWeekResponse1).schedule;

    expect(schedule.entries[0].title, "Klausur Elektronik und Messtechnik");
    expect(schedule.entries[0].start, DateTime(2021, 12, 13, 08, 00));
    expect(schedule.entries[0].end, DateTime(2021, 12, 13, 10, 00));
    expect(schedule.entries[0].type, ScheduleEntryType.Exam);
    expect(schedule.entries[0].professor, "Man, R.");
    expect(schedule.entries[0].room,
        "TEA20,H031, Hörsaal,N003, Hörsaal,N004, Hörsaal");

    expect(schedule.entries.length, 7);
  });

  test('Rapla robust parse', () async {
    var parser = RaplaResponseParser();

    var result = parser.parseSchedule(invalidRaplaPage);
    var schedule = result.schedule;
    var errors = result.errors;

    expect(errors.length, 3);
    expect(schedule.entries.length, 5);
  });
}
