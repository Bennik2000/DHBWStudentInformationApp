import 'package:dhbwstudentapp/common/data/database_access.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';

class DateEntryRepository {
  final DatabaseAccess _database;

  DateEntryRepository(this._database);

  Future<List<DateEntry>> queryAllDateEntries(
    String? databaseName,
    String? year,
  ) async {
    final rows = await _database.queryRows(
      DateEntry.tableName,
      where: "databaseName=? AND year=?",
      whereArgs: [databaseName, year],
    );

    return _rowsToDateEntries(rows);
  }

  Future<List<DateEntry?>> queryDateEntriesBetween(
    String databaseName,
    String year,
    DateTime start,
    DateTime end,
  ) async {
    final rows = await _database.queryRows(
      DateEntry.tableName,
      where: "date>=? AND date<=? AND databaseName=? AND year=?",
      whereArgs: [
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
        databaseName,
        year,
      ],
    );

    return _rowsToDateEntries(rows);
  }

  Future<List<DateEntry>> queryDateEntriesAfter(
    String? databaseName,
    String? year,
    DateTime date,
  ) async {
    final rows = await _database.queryRows(
      DateEntry.tableName,
      where: "date>=? AND databaseName=? AND year=?",
      whereArgs: [
        date.millisecondsSinceEpoch,
        databaseName,
        year,
      ],
    );

    return _rowsToDateEntries(rows);
  }

  Future<List<DateEntry>> queryDateEntriesBefore(
    String? databaseName,
    String? year,
    DateTime date,
  ) async {
    final rows = await _database.queryRows(
      DateEntry.tableName,
      where: "date<=? AND databaseName=? AND year=?",
      whereArgs: [
        date.millisecondsSinceEpoch,
        databaseName,
        year,
      ],
    );

    return _rowsToDateEntries(rows);
  }

  Future saveDateEntry(DateEntry entry) async {
    final row = entry.toJson();
    await _database.insert(DateEntry.tableName, row);
  }

  Future saveDateEntries(List<DateEntry> entries) async {
    for (final entry in entries) {
      await saveDateEntry(entry);
    }
  }

  Future deleteAllDateEntries(
    String? databaseName,
    String? year,
  ) async {
    await _database.deleteWhere(
      DateEntry.tableName,
      where: "databaseName=? AND year=?",
      whereArgs: [
        databaseName,
        year,
      ],
    );
  }

  List<DateEntry> _rowsToDateEntries(List<Map<String, dynamic>> rows) {
    final dateEntries = <DateEntry>[];

    for (final row in rows) {
      dateEntries.add(
        DateEntry.fromJson(row),
      );
    }

    return dateEntries;
  }
}
