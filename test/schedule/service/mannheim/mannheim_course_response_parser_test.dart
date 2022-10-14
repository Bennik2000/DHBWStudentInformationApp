import 'dart:io';

import 'package:dhbwstudentapp/schedule/service/mannheim/mannheim_course_response_parser.dart';
import 'package:test/test.dart';

Future<void> main() async {
  final coursePage = await File(Directory.current.absolute.path +
          '/test/schedule/service/mannheim/html_resources/mannheim_ical.html',)
      .readAsString();

  test('Mannheim course parser parses correctly', () async {
    final parser = MannheimCourseResponseParser();

    final courses = parser.parseCoursePage(coursePage);

    expect(courses.length, 8);

    expect(courses[0].name, "TINF20 IT1");
    expect(courses[1].name, "TINF20 IT2");
    expect(courses[2].name, "WIB17 A");
    expect(
      courses[2].icalUrl,
      "http://vorlesungsplan.dhbw-mannheim.de/ical.php?uid=7201001",
    );
    expect(courses[3].name, "WIB17 B");
    expect(
      courses[3].icalUrl,
      "http://vorlesungsplan.dhbw-mannheim.de/ical.php?uid=7202001",
    );
    expect(courses[4].name, "WRSW20 AC2");
    expect(courses[5].name, "WRSW20 ST1");
    expect(courses[6].name, "WRSW20 ST2");
    expect(courses[7].name, "WSTL20 D");
    expect(
      courses[7].icalUrl,
      "http://vorlesungsplan.dhbw-mannheim.de/ical.php?uid=8113001",
    );
  });
}
