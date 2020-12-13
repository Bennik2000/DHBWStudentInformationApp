import 'package:dhbwstudentapp/common/data/database_access.dart';
import 'package:dhbwstudentapp/schedule/data/schedule_entry_entity.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';

class ScheduleEntryRepository {
  final DatabaseAccess _database;

  ScheduleEntryRepository(this._database);

  Future<Schedule> queryScheduleForDay(DateTime date) async {
    return queryScheduleBetweenDates(date, date.add(const Duration(days: 1)));
  }

  Future<Schedule> queryScheduleBetweenDates(
      DateTime start, DateTime end) async {
    var rows = await _database.queryRows(
      ScheduleEntryEntity.tableName(),
      where: "end>? AND start<?",
      whereArgs: [
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      ],
    );

    var schedule = Schedule();

    for (var row in rows) {
      schedule.addEntry(
        ScheduleEntryEntity.fromMap(row).asScheduleEntry(),
      );
    }

    return schedule;
  }

  Future<ScheduleEntry> queryExistingScheduleEntry(ScheduleEntry entry) async {
    var rows = await _database.queryRows(
      ScheduleEntryEntity.tableName(),
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

    return ScheduleEntryEntity.fromMap(rows[0]).asScheduleEntry();
  }

  Future<ScheduleEntry> queryNextScheduleEntry(DateTime dateTime) async {
    var nextScheduleEntry = await _database.queryRows(
      ScheduleEntryEntity.tableName(),
      where: "start>?",
      whereArgs: [dateTime.millisecondsSinceEpoch],
      limit: 1,
      orderBy: "start ASC",
    );

    var entriesList = nextScheduleEntry.toList();

    if (entriesList.length == 1) {
      return ScheduleEntryEntity.fromMap(entriesList[0]).asScheduleEntry();
    }

    return null;
  }

  Future<void> saveScheduleEntry(ScheduleEntry entry) async {
    var row = ScheduleEntryEntity.fromModel(entry).toMap();

    var existingEntry = await queryExistingScheduleEntry(entry);

    if (existingEntry != null) {
      entry.id = existingEntry.id;
      return;
    }

    if (entry.id == null) {
      var id = await _database.insert(ScheduleEntryEntity.tableName(), row);
      entry.id = id;
    } else {
      await _database.update(ScheduleEntryEntity.tableName(), row);
    }
  }

  Future<void> saveSchedule(Schedule schedule) async {
    for (var entry in schedule.entries ?? []) {
      saveScheduleEntry(entry);
    }
  }

  Future<void> deleteScheduleEntry(ScheduleEntry entry) async {
    await _database.delete(ScheduleEntryEntity.tableName(), entry.id);
  }

  Future<void> deleteScheduleEntriesBetween(
      DateTime start, DateTime end) async {
    await _database.deleteWhere(
      ScheduleEntryEntity.tableName(),
      where: "start>=? AND end<=?",
      whereArgs: [
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      ],
    );
  }

  Future<void> deleteAllScheduleEntries() async {
    await _database.deleteWhere(
      ScheduleEntryEntity.tableName(),
      where: "1=1",
      whereArgs: [],
    );
  }
}
