import 'dart:io';

import 'package:dhbwstudentapp/schedule/service/rapla/rapla_response_parser.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var raplaPage = await new File(Directory.current.absolute.path +
          '/test/schedule/service/rapla/html_resources/rapla_response.html')
      .readAsString();

  test('Rapla correctly read all classes', () async {
    var parser = RaplaResponseParser();

    var schedule = parser.parseSchedule(raplaPage);

    expect(schedule.entries.length, 8);

    expect(schedule.entries[0].title == "Online - Netztechnik I");
    expect(schedule.entries[0].start == "Online - Netztechnik I");

    for (var entry in schedule.entries) {
      print(entry.title);
    }
  });
}
