import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> reportException(ex, StackTrace trace) async {
  print("Reporting exception to crashlytics: $ex with stack trace $trace");

  await Crashlytics.instance.recordError(ex, trace);
}
