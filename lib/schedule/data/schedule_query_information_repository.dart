import 'package:dhbwstudentapp/common/data/database_access.dart';
import 'package:dhbwstudentapp/schedule/data/schedule_query_information_entity.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_information.dart';

class ScheduleQueryInformationRepository {
  final DatabaseAccess _database;

  ScheduleQueryInformationRepository(this._database);

  Future<DateTime?> getOldestQueryTimeBetweenDates(
      DateTime start, DateTime end) async {
    var oldestQueryTimeDate = await _database.queryAggregator(
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
      DateTime start, DateTime end) async {
    var rows = await _database.queryRows(
      ScheduleQueryInformationEntity.tableName(),
      where: "start<=? AND end>=?",
      whereArgs: [
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      ],
    );

    var scheduleQueryInformation = <ScheduleQueryInformation?>[];

    for (var row in rows) {
      scheduleQueryInformation.add(
        ScheduleQueryInformationEntity.fromMap(row)
            .asScheduleQueryInformation(),
      );
    }

    return scheduleQueryInformation;
  }

  Future<void> saveScheduleQueryInformation(
      ScheduleQueryInformation queryInformation) async {
    await _database.deleteWhere(
      ScheduleQueryInformationEntity.tableName(),
      where: "start=? AND end=?",
      whereArgs: [
        queryInformation.start.millisecondsSinceEpoch,
        queryInformation.end.millisecondsSinceEpoch
      ],
    );

    await _database.insert(
      ScheduleQueryInformationEntity.tableName(),
      ScheduleQueryInformationEntity.fromModel(queryInformation).toMap(),
    );
  }

  Future<void> deleteAllQueryInformation() async {
    await _database.deleteWhere(
      ScheduleQueryInformationEntity.tableName(),
      where: "1=1",
      whereArgs: [],
    );
  }
}
