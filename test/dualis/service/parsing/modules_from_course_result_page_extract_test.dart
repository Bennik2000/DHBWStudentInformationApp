import 'dart:io';

import 'package:dhbwstudentapp/dualis/service/parsing/modules_from_course_result_page_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var courseResultsPage = await File(Directory.current.absolute.path +
          '/test/dualis/service/parsing/html_resources/course_results.html')
      .readAsString();

  test('ModulesFromCourseResultPageExtract', () async {
    var extract = ModulesFromCourseResultPageExtract();

    var modules = extract.extractModulesFromCourseResultPage(
        courseResultsPage, "www.endpoint.com");

    expect(modules.length, 3);

    expect(modules[1].id, "T3INF1001");
    expect(modules[1].name, "Mathematik I");
    expect(modules[1].state, null);
    expect(modules[1].credits, "8,0");
    expect(modules[1].finalGrade, "4,0");
    expect(modules[1].detailsUrl,
        "www.endpoint.com/scripts/mgrqispi.dll?APPNAME=CampusNet&PRGNAME=RESULTDETAILS&ARGUMENTS=-N123456789876543,-N000307,-N121212121212121");
  });

  test('ModulesFromCourseResultPageExtract invalid html throws exception',
      () async {
    var extract = ModulesFromCourseResultPageExtract();

    try {
      extract.extractModulesFromCourseResultPage("Lorem ipsum", "");
    } on ParseException {
      return;
    }

    fail("Exception not thrown!");
  });
}
