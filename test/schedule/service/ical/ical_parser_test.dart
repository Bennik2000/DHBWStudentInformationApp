import 'dart:io';

import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:dhbwstudentapp/schedule/service/ical/ical_parser.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var icalFile = await File(Directory.current.absolute.path +
          '/test/schedule/service/ical/file_resources/ical_test.ics')
      .readAsString();

  test('ical correctly read all entries', () async {
    var parser = IcalParser();

    var schedule = parser.parseIcal(icalFile).schedule;

    expect(schedule.entries.length, 3);

    expect(schedule.entries[0].title, "Angewandte Mathematik");
    expect(schedule.entries[0].start, DateTime(2019, 04, 01, 10, 00, 00));
    expect(schedule.entries[0].end, DateTime(2019, 04, 01, 14, 30, 00));
    expect(schedule.entries[0].type, ScheduleEntryType.Class);
    expect(schedule.entries[0].room, "Raum 035B");

    expect(schedule.entries[1].title, "Elektronik");
    expect(schedule.entries[1].start, DateTime(2019, 04, 02, 08, 00, 00));
    expect(schedule.entries[1].end, DateTime(2019, 04, 02, 14, 00, 00));
    expect(schedule.entries[1].type, ScheduleEntryType.Class);
    expect(schedule.entries[1].room, "Raum 035B");

    expect(schedule.entries[2].title, "Informatik");
    expect(schedule.entries[2].start, DateTime(2019, 04, 03, 09, 00, 00));
    expect(schedule.entries[2].end, DateTime(2019, 04, 03, 12, 15, 00));
    expect(schedule.entries[2].type, ScheduleEntryType.Class);
    expect(schedule.entries[2].room, "Raum 035B");
  });
}
