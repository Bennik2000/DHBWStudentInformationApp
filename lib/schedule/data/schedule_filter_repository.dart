import 'package:dhbwstudentapp/common/data/database_access.dart';

class ScheduleFilterRepository {
  final DatabaseAccess _database;

  const ScheduleFilterRepository(this._database);

  Future<List<String?>> queryAllHiddenNames() async {
    final rows = await _database.queryRows("ScheduleEntryFilters");

    final names = rows.map((e) => e['title'] as String?).toList();
    return names;
  }

  Future<void> saveAllHiddenNames(List<String?> hiddenNames) async {
    await _database.deleteWhere("ScheduleEntryFilters");

    for (final name in hiddenNames) {
      await _database.insert("ScheduleEntryFilters", {'title': name});
    }
  }
}
