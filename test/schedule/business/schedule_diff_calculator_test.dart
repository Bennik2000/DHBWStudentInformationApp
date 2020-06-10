import 'package:dhbwstuttgart/schedule/business/schedule_diff_calculator.dart';
import 'package:dhbwstuttgart/schedule/model/schedule.dart';
import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';
import 'package:test/test.dart';

void main() {
  test('Diff detect identical schedules', () async {
    var calculator = ScheduleDiffCalculator();

    var oldSchedule = generateSchedule();
    var newSchedule = generateSchedule();

    var diff = calculator.calculateDiff(oldSchedule, newSchedule);

    expect(diff.addedEntries.length, 0);
    expect(diff.removedEntries.length, 0);
    expect(diff.updatedEntries.length, 0);
  });

  test('Diff detect removed entry', () async {
    var calculator = ScheduleDiffCalculator();

    var oldSchedule = generateSchedule();
    var newSchedule = generateSchedule();

    var removedEntry = oldSchedule.entries[0];
    newSchedule.entries.removeAt(0);

    var diff = calculator.calculateDiff(oldSchedule, newSchedule);

    expect(diff.removedEntries.length, 1);
    expect(diff.removedEntries[0], removedEntry);
    expect(diff.addedEntries.length, 0);
    expect(diff.updatedEntries.length, 0);
  });

  test('Diff detect new entry', () async {
    var calculator = ScheduleDiffCalculator();

    var oldSchedule = generateSchedule();
    var newSchedule = generateSchedule();

    var newEntry = ScheduleEntry(
      room: "Room3",
      type: ScheduleEntryType.Class,
      title: "Project management",
      professor: "Sam",
      details: "ipsum",
      start: DateTime(2020, 06, 09, 17, 00),
      end: DateTime(2020, 06, 09, 18, 00),
    );

    newSchedule.addEntry(newEntry);

    var diff = calculator.calculateDiff(oldSchedule, newSchedule);

    expect(diff.addedEntries.length, 1);
    expect(diff.addedEntries[0], newEntry);
    expect(diff.removedEntries.length, 0);
    expect(diff.updatedEntries.length, 0);
  });

  test('Diff detect changed entry (time)', () async {
    var calculator = ScheduleDiffCalculator();

    var oldSchedule = generateSchedule();
    var newSchedule = generateSchedule();

    var updatedEntry = ScheduleEntry(
      room: newSchedule.entries[0].room,
      type: newSchedule.entries[0].type,
      title: newSchedule.entries[0].title,
      professor: newSchedule.entries[0].professor,
      details: newSchedule.entries[0].details,
      start: newSchedule.entries[0].start.add(Duration(minutes: 15)),
      end: newSchedule.entries[0].end,
    );
    newSchedule.entries[0] = updatedEntry;

    var diff = calculator.calculateDiff(oldSchedule, newSchedule);

    expect(diff.addedEntries.length, 0);
    expect(diff.removedEntries.length, 0);
    expect(diff.updatedEntries.length, 1);
    expect(diff.updatedEntries[0].properties.length, 1);
    expect(diff.updatedEntries[0].properties[0], "start");
    expect(diff.updatedEntries[0].entry, updatedEntry);
  });

  test('Diff detect changed entry (start and room)', () async {
    var calculator = ScheduleDiffCalculator();

    var oldSchedule = generateSchedule();
    var newSchedule = generateSchedule();

    var updatedEntry = ScheduleEntry(
      room: "Changed room",
      type: newSchedule.entries[0].type,
      title: newSchedule.entries[0].title,
      professor: newSchedule.entries[0].professor,
      details: newSchedule.entries[0].details,
      start: newSchedule.entries[0].start.add(Duration(minutes: 15)),
      end: newSchedule.entries[0].end,
    );
    newSchedule.entries[0] = updatedEntry;

    var diff = calculator.calculateDiff(oldSchedule, newSchedule);

    expect(diff.addedEntries.length, 0);
    expect(diff.removedEntries.length, 0);
    expect(diff.updatedEntries.length, 1);
    expect(diff.updatedEntries[0].properties.length, 2);
    expect(diff.updatedEntries[0].properties[0], "start");
    expect(diff.updatedEntries[0].properties[1], "room");
    expect(diff.updatedEntries[0].entry, updatedEntry);
  });
}

Schedule generateSchedule() {
  var scheduleEntries = <ScheduleEntry>[
    ScheduleEntry(
      room: "Room1",
      type: ScheduleEntryType.Class,
      title: "Chemistry",
      professor: "Mr. White",
      details: "We will make breaks",
      start: DateTime(2020, 06, 09, 10, 00),
      end: DateTime(2020, 06, 09, 12, 00),
    ),
    ScheduleEntry(
      room: "Room2",
      type: ScheduleEntryType.Class,
      title: "Computer Science",
      professor: "Mr. Turing",
      details: "Lorem",
      start: DateTime(2020, 06, 09, 13, 00),
      end: DateTime(2020, 06, 09, 14, 00),
    ),
    ScheduleEntry(
      room: "Room3",
      type: ScheduleEntryType.Class,
      title: "Physics",
      professor: "Mr. Hawking",
      details: "ipsum",
      start: DateTime(2020, 06, 09, 15, 00),
      end: DateTime(2020, 06, 09, 16, 00),
    ),
  ];

  return Schedule.fromList(scheduleEntries);
}
