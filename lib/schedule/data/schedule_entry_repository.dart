import 'package:dhbwstudentapp/common/data/database_access.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';

class ScheduleEntryRepository {
  final DatabaseAccess _database;

  ScheduleEntryRepository(this._database);

  Future<Schedule> queryScheduleForDay(DateTime date) async {
    return queryScheduleBetweenDates(date, date.add(const Duration(days: 1)));
  }

  Future<Schedule> queryScheduleBetweenDates(
    DateTime start,
    DateTime end,
  ) async {
    final rows = await _database.queryRows(
      ScheduleEntry.tableName,
      where: "end>? AND start<?",
      whereArgs: [
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      ],
    );

    final entries = <ScheduleEntry>[];
    for (final row in rows) {
      entries.add(ScheduleEntry.fromJson(row));
    }

    return Schedule(entries: entries);
  }

  Future<ScheduleEntry?> queryExistingScheduleEntry(ScheduleEntry entry) async {
    final rows = await _database.queryRows(
      ScheduleEntry.tableName,
      where: "start=? AND end=? AND title=? AND details=? AND professor=?",
      whereArgs: [
        entry.start.millisecondsSinceEpoch,
        entry.end.millisecondsSinceEpoch,
        entry.title,
        entry.details,
        entry.professor,
      ],
    );

    if (rows.isEmpty) return null;

    return ScheduleEntry.fromJson(rows[0]);
  }

  Future<ScheduleEntry?> queryNextScheduleEntry(DateTime dateTime) async {
    final nextScheduleEntry = await _database.queryRows(
      ScheduleEntry.tableName,
      where: "start>?",
      whereArgs: [dateTime.millisecondsSinceEpoch],
      limit: 1,
      orderBy: "start ASC",
    );

    final entriesList = nextScheduleEntry.toList();

    if (entriesList.length == 1) {
      return ScheduleEntry.fromJson(entriesList[0]);
    }

    return null;
  }

  Future<List<String?>> queryAllNamesOfScheduleEntries() async {
    final allNames = await _database.rawQuery(
      "SELECT DISTINCT title FROM  ScheduleEntries",
      [],
    );

    return allNames.map((e) => e["title"] as String?).toList();
  }

  Future<void> saveScheduleEntry(ScheduleEntry entry) async {
    final existingEntry = await queryExistingScheduleEntry(entry);

    if (existingEntry != null) {
      entry = entry.copyWith.id(existingEntry.id);
      return;
    }

    final row = entry.toJson();
    if (entry.id == null) {
      final id = await _database.insert(ScheduleEntry.tableName, row);
      entry = entry.copyWith.id(id);
    } else {
      await _database.update(ScheduleEntry.tableName, row);
    }
  }

  Future<void> saveSchedule(Schedule schedule) async {
    for (final entry in schedule.entries) {
      saveScheduleEntry(entry);
    }
  }

  Future<void> deleteScheduleEntry(ScheduleEntry entry) async {
    await _database.delete(ScheduleEntry.tableName, entry.id);
  }

  Future<void> deleteScheduleEntriesBetween(
    DateTime start,
    DateTime end,
  ) async {
    await _database.deleteWhere(
      ScheduleEntry.tableName,
      where: "start>=? AND end<=?",
      whereArgs: [
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      ],
    );
  }

  Future<void> deleteAllScheduleEntries() async {
    await _database.deleteWhere(
      ScheduleEntry.tableName,
      where: "1=1",
      whereArgs: [],
    );
  }
}
