import 'dart:io';

import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/urls_from_main_page_extract.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var mainPage = await File(Directory.current.absolute.path +
          '/test/dualis/service/parsing/html_resources/main_page.html')
      .readAsString();

  test('UrlsFromMainPageExtract', () async {
    var extract = UrlsFromMainPageExtract();

    var mainPageUrls = extract.parseMainPage(mainPage, "www.endpoint.com");

    expect(mainPageUrls.studentResultsUrl,
        "www.endpoint.com/scripts/mgrqispi.dll?APPNAME=CampusNet&PRGNAME=STUDENT_RESULT&ARGUMENTS=-N123456789876543,-N000310,-N0,-N000000000000000,-N000000000000000,-N000000000000000,-N0,-N000000000000000");
    expect(mainPageUrls.semesterCourseResultUrls, {});
    expect(mainPageUrls.courseResultUrl,
        "www.endpoint.com/scripts/mgrqispi.dll?APPNAME=CampusNet&PRGNAME=COURSERESULTS&ARGUMENTS=-N123456789876543,-N000307,");
  });

  test('UrlsFromMainPageExtract invalid html throws exception', () async {
    var extract = UrlsFromMainPageExtract();

    try {
      extract.parseMainPage("Lorem ipsum", "");
    } on ParseException {
      return;
    }

    fail("Exception not thrown!");
  });
}
