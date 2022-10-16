import 'package:dhbwstudentapp/common/data/database_access.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_information.dart';

class ScheduleQueryInformationRepository {
  final DatabaseAccess _database;

  const ScheduleQueryInformationRepository(this._database);

  Future<DateTime?> getOldestQueryTimeBetweenDates(
    DateTime start,
    DateTime end,
  ) async {
    final oldestQueryTimeDate = await _database.queryAggregator(
      "SELECT MIN(queryTime) FROM ScheduleQueryInformation WHERE start<=? AND end>=?",
      [
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      ],
    );

    if (oldestQueryTimeDate == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(oldestQueryTimeDate);
  }

  Future<List<ScheduleQueryInformation?>> getQueryInformationBetweenDates(
    DateTime start,
    DateTime end,
  ) async {
    final rows = await _database.queryRows(
      ScheduleQueryInformation.tableName,
      where: "start<=? AND end>=?",
      whereArgs: [
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      ],
    );

    final scheduleQueryInformation = <ScheduleQueryInformation?>[];

    for (final row in rows) {
      scheduleQueryInformation.add(
        ScheduleQueryInformation.fromJson(row),
      );
    }

    return scheduleQueryInformation;
  }

  Future<void> saveScheduleQueryInformation(
    ScheduleQueryInformation queryInformation,
  ) async {
    await _database.deleteWhere(
      ScheduleQueryInformation.tableName,
      where: "start=? AND end=?",
      whereArgs: [
        queryInformation.start.millisecondsSinceEpoch,
        queryInformation.end.millisecondsSinceEpoch
      ],
    );

    await _database.insert(
      ScheduleQueryInformation.tableName,
      queryInformation.toJson(),
    );
  }

  Future<void> deleteAllQueryInformation() async {
    await _database.deleteWhere(
      ScheduleQueryInformation.tableName,
      where: "1=1",
      whereArgs: [],
    );
  }
}
