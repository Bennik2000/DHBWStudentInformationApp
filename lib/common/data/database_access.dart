import 'dart:io';

import 'package:dhbwstudentapp/common/data/database_path_provider.dart';
import 'package:dhbwstudentapp/common/data/sql_scripts.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseAccess {
  static const String _databaseName = "Database.db";
  static Database _databaseInstance;

  static const String idColumnName = "id";

  Future<Database> get _database async {
    if (_databaseInstance != null) return _databaseInstance;

    _databaseInstance = await _initDatabase();
    return _databaseInstance;
  }

  Future<Database> _initDatabase() async {
    final String path = await getDatabasePath(_databaseName);

    return await openDatabase(path,
        version: SqlScripts.databaseMigrationScripts.length,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade);
  }

  Future<void> _onCreate(Database db, int version) async {
    print("Initializing Database with version: $version");

    await _onUpgrade(db, 1, version);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
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

    for (int i = 0; i < (whereArgs?.length ?? 0); i++) {
      whereArgs[i] = whereArgs[i] ?? "";
    }

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

  Future<int> queryAggregator(String query, List<dynamic> arguments) async {
    Database db = await _database;
    return Sqflite.firstIntValue(await db.rawQuery(query, arguments));
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

  Future<int> deleteWhere(
    String table, {
    String where,
    List<dynamic> whereArgs,
  }) async {
    Database db = await _database;
    return await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }
}
