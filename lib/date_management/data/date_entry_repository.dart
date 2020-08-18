import 'package:dhbwstudentapp/common/data/database_access.dart';
import 'package:dhbwstudentapp/date_management/data/date_entry_entity.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';

class DateEntryRepository {
  final DatabaseAccess _database;

  DateEntryRepository(this._database);

  Future<List<DateEntry>> queryAllDateEntries() async {
    var rows = await _database.queryRows(
      DateEntryEntity.tableName(),
    );

    return _rowsToDateEntries(rows);
  }

  Future<List<DateEntry>> queryDateEntriesBetween(
      DateTime start, DateTime end) async {
    var rows = await _database.queryRows(
      DateEntryEntity.tableName(),
      where: "date>=? AND date<=?",
      whereArgs: [
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      ],
    );

    return _rowsToDateEntries(rows);
  }

  Future<List<DateEntry>> queryDateEntriesAfter(DateTime date) async {
    var rows = await _database.queryRows(
      DateEntryEntity.tableName(),
      where: "date>=?",
      whereArgs: [
        date.millisecondsSinceEpoch,
      ],
    );

    return _rowsToDateEntries(rows);
  }

  Future<List<DateEntry>> queryDateEntriesBefore(DateTime date) async {
    var rows = await _database.queryRows(
      DateEntryEntity.tableName(),
      where: "date<=?",
      whereArgs: [
        date.millisecondsSinceEpoch,
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

  Future deleteAllDateEntries() async {
    await _database.deleteWhere(
      DateEntryEntity.tableName(),
      where: "1==1",
    );
  }

  List<DateEntry> _rowsToDateEntries(List<Map<String, dynamic>> rows) {
    var dateEntries = <DateEntry>[];

    for (var row in rows) {
      dateEntries.add(
        new DateEntryEntity.fromMap(row).asDateEntry(),
      );
    }

    return dateEntries;
  }
}
