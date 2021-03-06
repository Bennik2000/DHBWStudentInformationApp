import 'package:dhbwstudentapp/common/data/database_access.dart';
import 'package:dhbwstudentapp/date_management/data/date_entry_entity.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';

class DateEntryRepository {
  final DatabaseAccess _database;

  DateEntryRepository(this._database);

  Future<List<DateEntry>> queryAllDateEntries(
    String databaseName,
    String year,
  ) async {
    var rows = await _database.queryRows(
      DateEntryEntity.tableName(),
      where: "databaseName=? AND year=?",
      whereArgs: [databaseName, year],
    );

    return _rowsToDateEntries(rows);
  }

  Future<List<DateEntry>> queryDateEntriesBetween(
    String databaseName,
    String year,
    DateTime start,
    DateTime end,
  ) async {
    var rows = await _database.queryRows(
      DateEntryEntity.tableName(),
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
    String databaseName,
    String year,
    DateTime date,
  ) async {
    var rows = await _database.queryRows(
      DateEntryEntity.tableName(),
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
    String databaseName,
    String year,
    DateTime date,
  ) async {
    var rows = await _database.queryRows(
      DateEntryEntity.tableName(),
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
    var row = DateEntryEntity.fromModel(entry).toMap();
    await _database.insert(DateEntryEntity.tableName(), row);
  }

  Future saveDateEntries(List<DateEntry> entries) async {
    for (var entry in entries) {
      await saveDateEntry(entry);
    }
  }

  Future deleteAllDateEntries(
    String databaseName,
    String year,
  ) async {
    await _database.deleteWhere(DateEntryEntity.tableName(),
        where: "databaseName=? AND year=?",
        whereArgs: [
          databaseName,
          year,
        ]);
  }

  List<DateEntry> _rowsToDateEntries(List<Map<String, dynamic>> rows) {
    var dateEntries = <DateEntry>[];

    for (var row in rows) {
      dateEntries.add(
        DateEntryEntity.fromMap(row).asDateEntry(),
      );
    }

    return dateEntries;
  }
}
