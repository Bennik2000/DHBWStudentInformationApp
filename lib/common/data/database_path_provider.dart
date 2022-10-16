import 'dart:io';

import 'package:app_group_directory/app_group_directory.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getDatabasePath(String databaseName) async {
  final Directory documentsDirectory = await getApplicationDocumentsDirectory();

  var path = join(documentsDirectory.path, databaseName);

  if (Platform.isIOS) {
    path = await _getiOSDatabasePathAndMigrate(path, databaseName);
  }

  return path;
}

Future<String> _getiOSDatabasePathAndMigrate(
  String oldPath,
  String databaseName,
) async {
  // Since the iOS widget needs access to the schedule database,
  // it must be saved in a group shared between the app module and the widget
  // module. "Migration" means that the database at the old path gets
  // copied to the new path
  assert(Platform.isIOS);

  final Directory? groupDirectory =
      await AppGroupDirectory.getAppGroupDirectory(
    'group.de.bennik2000.dhbwstudentapp',
  );

  final newPath = join(groupDirectory!.path, databaseName);

  final migrateSuccess = await _migrateOldDatabase(oldPath, newPath);

  if (!migrateSuccess) {
    print("Failed to migrate database");
  }

  return newPath;
}

Future<bool> _migrateOldDatabase(String oldPath, String newPath) async {
  try {
    final newFile = File(newPath);
    final oldFile = File(oldPath);

    if (await oldFile.exists() && !(await newFile.exists())) {
      print("Migrating database...");
      await oldFile.copy(newPath);
      await oldFile.delete();
    }
  } on Exception {
    return false;
  }

  return true;
}
