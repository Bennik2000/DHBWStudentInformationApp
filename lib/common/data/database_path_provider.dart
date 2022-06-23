import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:ios_app_group/ios_app_group.dart';

Future<String> getDatabasePath(String databaseName) async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();

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

  var groupDirectory = await IosAppGroup.getAppGroupDirectory(
    'group.de.bennik2000.dhbwstudentapp',
  );

  var newPath = join(groupDirectory.path, databaseName);

  var migrateSuccess = await _migrateOldDatabase(oldPath, newPath);

  if (!migrateSuccess) {
    print("Failed to migrate database");
  }

  return newPath;
}

Future<bool> _migrateOldDatabase(String oldPath, String newPath) async {
  try {
    var newFile = File(newPath);
    var oldFile = File(oldPath);

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
