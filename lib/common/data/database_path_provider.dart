import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:ios_app_group/ios_app_group.dart';

Future<String> getDatabasePath(String databaseName) async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();

  if (Platform.isIOS) {
    documentsDirectory = await IosAppGroup.getAppGroupDirectory(
        'group.de.bennik2000.dhbwstudentapp');
    // TODO: Copy old database to new directory
  }

  final String path = join(documentsDirectory.path, databaseName);

  print(path);

  return path;
}
