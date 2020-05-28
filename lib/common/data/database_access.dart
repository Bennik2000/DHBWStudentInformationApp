import 'dart:io';

import 'package:dhbwstuttgart/common/data/sql_scripts.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseAccess {
  static final _databaseName = "Database.db";
  static Database _databaseInstance;

  static final String idColumnName = "id";

  Future<Database> get _database async {
    if (_databaseInstance != null) return _databaseInstance;

    _databaseInstance = await _initDatabase();
    return _databaseInstance;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(path,
        version: SqlScripts.databaseMigrationScripts.length,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    print("Initializing Database with version: $version");

    await _onUpgrade(db, 1, version);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("Migrating database version: $oldVersion -> $newVersion");

    for (var i = oldVersion; i <= newVersion; i++) {
      print("   -> Execute migration to $i");

      for (var s in SqlScripts.databaseMigrationScripts[i - 1]) {
        print("   -> $s");
        await db.execute(s);
      }
    }
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await _database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await _database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryRows(String table,
      {bool distinct,
      List<String> columns,
      String where,
      List<dynamic> whereArgs,
      String groupBy,
      String having,
      String orderBy,
      int limit,
      int offset}) async {
    Database db = await _database;
    return await db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<int> queryRowCount(String table) async {
    Database db = await _database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(String table, Map<String, dynamic> row) async {
    Database db = await _database;
    int id = row[idColumnName];
    return await db
        .update(table, row, where: '$idColumnName = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, int id) async {
    Database db = await _database;
    return await db.delete(table, where: '$idColumnName = ?', whereArgs: [id]);
  }
}
