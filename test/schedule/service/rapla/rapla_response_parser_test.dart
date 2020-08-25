import 'dart:io';

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

    expect(schedule.entries[0].title, "Online - Netztechnik I");
    expect(schedule.entries[0].start, DateTime(2020, 09, 07, 09, 15));
    expect(schedule.entries[0].end, DateTime(2020, 09, 07, 11, 45));

    expect(schedule.entries[1].title, "Online - Semestereinführung");
    expect(schedule.entries[1].start, DateTime(2020, 09, 07, 12, 00));
    expect(schedule.entries[1].end, DateTime(2020, 09, 07, 12, 30));

    expect(schedule.entries[2].title, "Online - Messdatenerfassung");
    expect(schedule.entries[2].start, DateTime(2020, 09, 07, 13, 00));
    expect(schedule.entries[2].end, DateTime(2020, 09, 07, 14, 30));

    expect(schedule.entries[3].title, "Online - Formale Sprachen & Automaten");
    expect(schedule.entries[3].start, DateTime(2020, 09, 08, 08, 15));
    expect(schedule.entries[3].end, DateTime(2020, 09, 08, 11, 45));

    expect(schedule.entries[4].title, "Online - Signale & Systeme I");
    expect(schedule.entries[4].start, DateTime(2020, 09, 08, 13, 00));
    expect(schedule.entries[4].end, DateTime(2020, 09, 08, 15, 00));

    expect(schedule.entries[5].title, "Online - Angewandte Mathematik");
    expect(schedule.entries[5].start, DateTime(2020, 09, 09, 09, 00));
    expect(schedule.entries[5].end, DateTime(2020, 09, 09, 11, 45));

    expect(schedule.entries[6].title, "Online - SWE");
    expect(schedule.entries[6].start, DateTime(2020, 09, 10, 09, 15));
    expect(schedule.entries[6].end, DateTime(2020, 09, 10, 12, 00));

    expect(schedule.entries[7].title, "Online - Messdatenerfassung");
    expect(schedule.entries[7].start, DateTime(2020, 09, 10, 13, 00));
    expect(schedule.entries[7].end, DateTime(2020, 09, 10, 14, 30));
  });
}
