import 'dart:io';

import 'package:dhbwstudentapp/dualis/service/parsing/timeout_extract.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var monthlySchedulePage = await File(Directory.current.absolute.path +
          '/test/dualis/service/parsing/html_resources/monthly_schedule.html',)
      .readAsString();

  var timeoutPage = await File(Directory.current.absolute.path +
          '/test/dualis/service/parsing/html_resources/dualis_timeout.html',)
      .readAsString();

  test('DualisTimeoutExtract detect timeout page', () async {
    expect(TimeoutExtract().isTimeoutErrorPage(timeoutPage), isTrue);
  });

  test('DualisTimeoutExtract detect non timeout page', () async {
    expect(TimeoutExtract().isTimeoutErrorPage(monthlySchedulePage), isFalse);
  });
}
