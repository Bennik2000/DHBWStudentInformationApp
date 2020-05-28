import 'dart:core';

class SqlScripts {
  static final databaseMigrationScripts = [
    // Version 1 - init database
    [
      '''
CREATE TABLE IF NOT EXISTS ScheduleEntries
(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  start INTEGER,
  end INTEGER,
  title TEXT,
  details TEXT,
  professor TEXT
);
''',
    ],
  ];
}
