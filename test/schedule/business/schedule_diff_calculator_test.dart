import 'package:dhbwstudentapp/schedule/business/schedule_diff_calculator.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:test/test.dart';

void main() {
  test('Diff detect identical schedules', () async {
    final calculator = ScheduleDiffCalculator();

    final oldSchedule = generateSchedule();
    final newSchedule = generateSchedule();

    final diff = calculator.calculateDiff(oldSchedule, newSchedule);

    expect(diff.addedEntries.length, 0);
    expect(diff.removedEntries.length, 0);
    expect(diff.updatedEntries.length, 0);
  });

  test('Diff detect removed entry', () async {
    final calculator = ScheduleDiffCalculator();

    final oldSchedule = generateSchedule();
    final newSchedule = generateSchedule();

    final removedEntry = oldSchedule.entries[0];
    newSchedule.entries.removeAt(0);

    final diff = calculator.calculateDiff(oldSchedule, newSchedule);

    expect(diff.removedEntries.length, 1);
    expect(diff.removedEntries[0], removedEntry);
    expect(diff.addedEntries.length, 0);
    expect(diff.updatedEntries.length, 0);
  });

  test('Diff detect new entry', () async {
    final calculator = ScheduleDiffCalculator();

    final oldSchedule = generateSchedule();
    final newSchedule = generateSchedule();

    final newEntry = ScheduleEntry(
      room: "Room3",
      type: ScheduleEntryType.Class,
      title: "Project management",
      professor: "Sam",
      details: "ipsum",
      start: DateTime(2020, 06, 09, 17),
      end: DateTime(2020, 06, 09, 18),
    );

    newSchedule.entries.add(newEntry);

    final diff = calculator.calculateDiff(oldSchedule, newSchedule);

    expect(diff.addedEntries.length, 1);
    expect(diff.addedEntries[0], newEntry);
    expect(diff.removedEntries.length, 0);
    expect(diff.updatedEntries.length, 0);
  });

  test('Diff detect changed entry (time)', () async {
    final calculator = ScheduleDiffCalculator();

    final oldSchedule = generateSchedule();
    final newSchedule = generateSchedule();

    final updatedEntry = ScheduleEntry(
      room: newSchedule.entries[0].room,
      type: newSchedule.entries[0].type,
      title: newSchedule.entries[0].title,
      professor: newSchedule.entries[0].professor,
      details: newSchedule.entries[0].details,
      start: newSchedule.entries[0].start.add(const Duration(minutes: 15)),
      end: newSchedule.entries[0].end,
    );
    newSchedule.entries[0] = updatedEntry;

    final diff = calculator.calculateDiff(oldSchedule, newSchedule);

    expect(diff.addedEntries.length, 0);
    expect(diff.removedEntries.length, 0);
    expect(diff.updatedEntries.length, 1);
    expect(diff.updatedEntries[0].properties.length, 1);
    expect(diff.updatedEntries[0].properties[0], "start");
    expect(diff.updatedEntries[0].entry, updatedEntry);
  });

  test('Diff detect changed entry (start and room)', () async {
    final calculator = ScheduleDiffCalculator();

    final oldSchedule = generateSchedule();
    final newSchedule = generateSchedule();

    final updatedEntry = ScheduleEntry(
      room: "Changed room",
      type: newSchedule.entries[0].type,
      title: newSchedule.entries[0].title,
      professor: newSchedule.entries[0].professor,
      details: newSchedule.entries[0].details,
      start: newSchedule.entries[0].start.add(const Duration(minutes: 15)),
      end: newSchedule.entries[0].end,
    );
    newSchedule.entries[0] = updatedEntry;

    final diff = calculator.calculateDiff(oldSchedule, newSchedule);

    expect(diff.addedEntries.length, 0);
    expect(diff.removedEntries.length, 0);
    expect(diff.updatedEntries.length, 1);
    expect(diff.updatedEntries[0].properties.length, 2);
    expect(diff.updatedEntries[0].properties[0], "start");
    expect(diff.updatedEntries[0].properties[1], "room");
    expect(diff.updatedEntries[0].entry, updatedEntry);
  });

  test('Diff detect two changed entries of same name (start)', () async {
    final calculator = ScheduleDiffCalculator();

    final oldSchedule = generateSchedule();
    final newSchedule = generateSchedule();

    final updatedEntry1 = ScheduleEntry(
      room: newSchedule.entries[2].room,
      type: newSchedule.entries[2].type,
      title: newSchedule.entries[2].title,
      professor: newSchedule.entries[2].professor,
      details: newSchedule.entries[2].details,
      start: newSchedule.entries[2].start.add(const Duration(minutes: 15)),
      end: newSchedule.entries[2].end,
    );
    newSchedule.entries[2] = updatedEntry1;

    final updatedEntry2 = ScheduleEntry(
      room: newSchedule.entries[3].room,
      type: newSchedule.entries[3].type,
      title: newSchedule.entries[3].title,
      professor: newSchedule.entries[3].professor,
      details: newSchedule.entries[3].details,
      start: newSchedule.entries[3].start.add(const Duration(minutes: 15)),
      end: newSchedule.entries[3].end,
    );
    newSchedule.entries[3] = updatedEntry2;

    final diff = calculator.calculateDiff(oldSchedule, newSchedule);

    expect(diff.addedEntries.length, 0);
    expect(diff.removedEntries.length, 0);
    expect(diff.updatedEntries.length, 2);
    expect(diff.updatedEntries[0].properties.length, 1);
    expect(diff.updatedEntries[0].properties[0], "start");
    expect(diff.updatedEntries[0].entry, updatedEntry1);
    expect(diff.updatedEntries[1].properties.length, 1);
    expect(diff.updatedEntries[1].properties[0], "start");
    expect(diff.updatedEntries[1].entry, updatedEntry2);
  });
}

Schedule generateSchedule() {
  final scheduleEntries = <ScheduleEntry>[
    ScheduleEntry(
      room: "Room1",
      type: ScheduleEntryType.Class,
      title: "Chemistry",
      professor: "Mr. White",
      details: "We will make breaks",
      start: DateTime(2020, 06, 09, 10),
      end: DateTime(2020, 06, 09, 12),
    ),
    ScheduleEntry(
      room: "Room2",
      type: ScheduleEntryType.Class,
      title: "Computer Science",
      professor: "Mr. Turing",
      details: "Lorem",
      start: DateTime(2020, 06, 09, 13),
      end: DateTime(2020, 06, 09, 14),
    ),
    ScheduleEntry(
      room: "Room3",
      type: ScheduleEntryType.Class,
      title: "Physics",
      professor: "Mr. Hawking",
      details: "ipsum",
      start: DateTime(2020, 06, 09, 15),
      end: DateTime(2020, 06, 09, 16),
    ),
    ScheduleEntry(
      room: "Room3",
      type: ScheduleEntryType.Class,
      title: "Physics",
      professor: "Mr. Hawking",
      details: "ipsum",
      start: DateTime(2020, 06, 09, 17),
      end: DateTime(2020, 06, 09, 18),
    ),
  ];

  return Schedule(entries: scheduleEntries);
}
