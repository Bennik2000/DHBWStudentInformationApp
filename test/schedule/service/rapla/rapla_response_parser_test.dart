import 'dart:io';

import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:dhbwstudentapp/schedule/service/rapla/rapla_response_parser.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var raplaPage = await new File(Directory.current.absolute.path +
          '/test/schedule/service/rapla/html_resources/rapla_response.html')
      .readAsString();

  test('Rapla correctly read all classes', () async {
    var parser = RaplaResponseParser();

    var schedule = parser.parseSchedule(raplaPage);

    expect(schedule.entries.length, 8);

    expect(schedule.entries[0].title, "Netztechnik I");
    expect(schedule.entries[0].start, DateTime(2020, 09, 07, 09, 15));
    expect(schedule.entries[0].end, DateTime(2020, 09, 07, 11, 45));
    expect(schedule.entries[0].type, ScheduleEntryType.Online);
    expect(schedule.entries[0].professor, "Müller, Georg");

    expect(schedule.entries[1].title, "Semestereinführung");
    expect(schedule.entries[1].start, DateTime(2020, 09, 07, 12, 00));
    expect(schedule.entries[1].end, DateTime(2020, 09, 07, 12, 30));
    expect(schedule.entries[1].type, ScheduleEntryType.Online);

    expect(schedule.entries[2].title, "Messdatenerfassung");
    expect(schedule.entries[2].start, DateTime(2020, 09, 07, 13, 00));
    expect(schedule.entries[2].end, DateTime(2020, 09, 07, 14, 30));
    expect(schedule.entries[2].type, ScheduleEntryType.Online);

    expect(schedule.entries[3].title, "Formale Sprachen & Automaten");
    expect(schedule.entries[3].start, DateTime(2020, 09, 08, 08, 15));
    expect(schedule.entries[3].end, DateTime(2020, 09, 08, 11, 45));
    expect(schedule.entries[3].type, ScheduleEntryType.Online);

    expect(schedule.entries[4].title, "Signale & Systeme I");
    expect(schedule.entries[4].start, DateTime(2020, 09, 08, 13, 00));
    expect(schedule.entries[4].end, DateTime(2020, 09, 08, 15, 00));
    expect(schedule.entries[4].type, ScheduleEntryType.Online);

    expect(schedule.entries[5].title, "Angewandte Mathematik");
    expect(schedule.entries[5].start, DateTime(2020, 09, 09, 09, 00));
    expect(schedule.entries[5].end, DateTime(2020, 09, 09, 11, 45));
    expect(schedule.entries[5].type, ScheduleEntryType.Online);

    expect(schedule.entries[6].title, "SWE");
    expect(schedule.entries[6].start, DateTime(2020, 09, 10, 09, 15));
    expect(schedule.entries[6].end, DateTime(2020, 09, 10, 12, 00));
    expect(schedule.entries[6].type, ScheduleEntryType.Online);

    expect(schedule.entries[7].title, "Messdatenerfassung");
    expect(schedule.entries[7].start, DateTime(2020, 09, 10, 13, 00));
    expect(schedule.entries[7].end, DateTime(2020, 09, 10, 14, 30));
    expect(schedule.entries[7].type, ScheduleEntryType.Online);
  });
}
