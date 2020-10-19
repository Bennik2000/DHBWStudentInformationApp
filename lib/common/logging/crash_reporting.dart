import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

Future<void> reportException(ex, StackTrace trace) async {
  if (kReleaseMode) {
    print("Reporting exception to crashlytics: $ex with stack trace $trace");
    await FirebaseCrashlytics.instance.recordError(ex, trace);
  } else {
    print(
        "Did not report exception (not in release mode) to crashlytics: $ex with stack trace $trace");
  }
}
