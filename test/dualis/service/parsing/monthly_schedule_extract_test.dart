import 'dart:io';

import 'package:dhbwstudentapp/dualis/service/parsing/monthly_schedule_extract.dart';
import 'package:test/test.dart';

Future<void> main() async {
  final monthlySchedulePage = await File(Directory.current.absolute.path +
          '/test/dualis/service/parsing/html_resources/monthly_schedule.html',)
      .readAsString();

  test('MonthlyScheduleExtract extract all appointments', () async {
    final extract = MonthlyScheduleExtract();

    final modules = extract.extractScheduleFromMonthly(monthlySchedulePage);

    expect(modules.entries.length, 7);

    final entryTitles = [
      "HOR-TMB20xxKE1 - 3. Sem. Antriebstechnik",
      "HOR-TMB20xxKE1/KE2 -  3. Sem. Konstruktion III",
      "HOR-TMB20xxKE1/KE2  3 . Sem. Thermodynamik Grundlagen 1",
      "HOR-TMB20xxKE1 3. Sem3 Technische Mechanik  + Festigkeitslehre III",
      "HOR-TMB20xxKE1 3. Sem. Mathematik III",
      "HOR-TMB20xxKE1 3. Sem3 Technische Mechanik  + Festigkeitslehre III",
      "HOR-TMB20xxKE1 3. Sem. Managementsysteme -Projektmanagement",
    ];

    final startAndEndTime = [
      [DateTime(2020, 09, 08, 08), DateTime(2020, 09, 08, 12, 15)],
      [DateTime(2020, 09, 10, 08, 30), DateTime(2020, 09, 10, 12, 45)],
      [DateTime(2020, 09, 10, 13, 30), DateTime(2020, 09, 10, 16, 45)],
      [DateTime(2020, 09, 14, 09), DateTime(2020, 09, 14, 11, 30)],
      [DateTime(2020, 09, 18, 08, 15), DateTime(2020, 09, 18, 11, 15)],
      [DateTime(2020, 09, 21, 08, 30), DateTime(2020, 09, 21, 11, 45)],
      [DateTime(2020, 09, 21, 13, 30), DateTime(2020, 09, 21, 16, 45)],
    ];

    for (int i = 0; i < 7; i++) {
      expect(modules.entries[i].title, entryTitles[i]);
      expect(modules.entries[i].start, startAndEndTime[i][0]);
      expect(modules.entries[i].end, startAndEndTime[i][1]);
    }
  });
}
