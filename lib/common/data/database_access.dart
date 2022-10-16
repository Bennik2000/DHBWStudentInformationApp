import 'package:dhbwstudentapp/common/data/database_path_provider.dart';
import 'package:dhbwstudentapp/common/data/sql_scripts.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseAccess {
  const DatabaseAccess();

  static const String _databaseName = "Database.db";
  static Database? _databaseInstance;

  static const String idColumnName = "id";

  Future<Database> get _database async {
    return _databaseInstance ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final String path = await getDatabasePath(_databaseName);

    return openDatabase(
      path,
      version: SqlScripts.databaseMigrationScripts.length,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    print("Initializing Database with version: $version");

    await _onUpgrade(db, 1, version);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("Migrating database version: $oldVersion -> $newVersion");

    for (var i = oldVersion; i <= newVersion; i++) {
      print("   -> Execute migration to $i");

      for (final s in SqlScripts.databaseMigrationScripts[i - 1]) {
        print("   -> $s");
        await db.execute(s);
      }
    }
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    final Database db = await _database;
    return db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    final Database db = await _database;
    return db.query(table);
  }

  Future<List<Map<String, dynamic>>> rawQuery(
    String sql,
    List<dynamic> parameters,
  ) async {
    final Database db = await _database;
    return db.rawQuery(sql, parameters);
  }

  Future<List<Map<String, dynamic>>> queryRows(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final Database db = await _database;

    // TODO: [Leptopoda] is there a reason this is done? or at maybe use whereArgs.removeWhere()
    for (int i = 0; i < (whereArgs?.length ?? 0); i++) {
      whereArgs![i] = whereArgs[i] ?? "";
    }

    return db.query(
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

  Future<int?> queryRowCount(String table) async {
    final Database db = await _database;
    return Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $table'),
    );
  }

  Future<int?> queryAggregator(String query, List<dynamic> arguments) async {
    final Database db = await _database;
    return Sqflite.firstIntValue(await db.rawQuery(query, arguments));
  }

  Future<int> update(String table, Map<String, dynamic> row) async {
    final Database db = await _database;
    final id = row[idColumnName];
    return db.update(table, row, where: '$idColumnName = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, int? id) async {
    final Database db = await _database;
    return db.delete(table, where: '$idColumnName = ?', whereArgs: [id]);
  }

  Future<int> deleteWhere(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final Database db = await _database;
    return db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }
}
