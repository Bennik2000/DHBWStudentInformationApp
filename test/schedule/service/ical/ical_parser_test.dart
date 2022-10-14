import 'dart:io';

import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:dhbwstudentapp/schedule/service/ical/ical_parser.dart';
import 'package:test/test.dart';

Future<void> main() async {
  final icalFile = await File('${Directory.current.absolute.path}/test/schedule/service/ical/file_resources/ical_test.ics',)
      .readAsString();

  test('ical correctly read all entries', () async {
    final parser = IcalParser();

    final schedule = parser.parseIcal(icalFile).schedule;

    expect(schedule.entries.length, 3);

    expect(schedule.entries[0].title, "Angewandte Mathematik");
    expect(schedule.entries[0].start, DateTime(2019, 04, 01, 10));
    expect(schedule.entries[0].end, DateTime(2019, 04, 01, 14, 30));
    expect(schedule.entries[0].type, ScheduleEntryType.Class);
    expect(schedule.entries[0].room, "Raum 035B");

    expect(schedule.entries[1].title, "Elektronik");
    expect(schedule.entries[1].start, DateTime(2019, 04, 02, 08));
    expect(schedule.entries[1].end, DateTime(2019, 04, 02, 14));
    expect(schedule.entries[1].type, ScheduleEntryType.Class);
    expect(schedule.entries[1].room, "Raum 035B");

    expect(schedule.entries[2].title, "Informatik");
    expect(schedule.entries[2].start, DateTime(2019, 04, 03, 09));
    expect(schedule.entries[2].end, DateTime(2019, 04, 03, 12, 15));
    expect(schedule.entries[2].type, ScheduleEntryType.Class);
    expect(schedule.entries[2].room, "Raum 035B");
  });
}
