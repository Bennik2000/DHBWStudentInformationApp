import 'package:dhbwstudentapp/common/data/database_access.dart';

class ScheduleFilterRepository {
  final DatabaseAccess _database;

  ScheduleFilterRepository(this._database);

  Future<List<String>> queryAllHiddenNames() async {
    var rows = await _database.queryRows("ScheduleEntryFilters");

    var names = rows.map((e) => e['title'] as String).toList();
    return names;
  }

  Future<void> saveAllHiddenNames(List<String> hiddenNames) async {
    await _database.deleteWhere("ScheduleEntryFilters");

    for (var name in hiddenNames) {
      await _database.insert("ScheduleEntryFilters", {'title': name});
    }
  }
}
