import 'dart:io';

import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/semesters_from_course_result_page_extract.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var courseResultsPage = await new File(Directory.current.absolute.path +
          '/test/dualis/service/parsing/html_resources/course_results.html')
      .readAsString();

  test('SemestersFromCourseResultPageExtract', () async {
    var extract = SemestersFromCourseResultPageExtract();

    var semesters = extract.extractSemestersFromCourseResults(
      courseResultsPage,
      "www.endpoint.com",
    );

    expect(semesters.length, 2);

    expect(semesters[0].semesterName, "SoSe yyyy");
    expect(semesters[0].semesterCourseResultsUrl,
        "www.endpoint.com/scripts/mgrqispi.dll?APPNAME=CampusNet&PRGNAME=COURSERESULTS&ARGUMENTS=-N123456789876543,-N000307,-N000000012345000");

    expect(semesters[1].semesterName, "WiSe xx/yy");
    expect(semesters[1].semesterCourseResultsUrl,
        "www.endpoint.com/scripts/mgrqispi.dll?APPNAME=CampusNet&PRGNAME=COURSERESULTS&ARGUMENTS=-N123456789876543,-N000307,-N000000015048000");
  });

  test('SemestersFromCourseResultPageExtract invalid html throws exception',
      () async {
    var extract = SemestersFromCourseResultPageExtract();

    try {
      extract.extractSemestersFromCourseResults("Lorem ipsum", "");
    } on ParseException {
      return;
    }

    fail("Exception not thrown!");
  });
}
