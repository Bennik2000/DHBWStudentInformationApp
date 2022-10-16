import 'dart:io';

import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/urls_from_main_page_extract.dart';
import 'package:test/test.dart';

Future<void> main() async {
  final mainPage = await File(
    '${Directory.current.absolute.path}/test/dualis/service/parsing/html_resources/main_page.html',
  ).readAsString();

  test('UrlsFromMainPageExtract', () async {
    const extract = UrlsFromMainPageExtract();

    final mainPageUrls = DualisUrls();

    extract.parseMainPage(mainPage, mainPageUrls, "www.endpoint.com");

    expect(
      mainPageUrls.studentResultsUrl,
      "www.endpoint.com/scripts/mgrqispi.dll?APPNAME=CampusNet&PRGNAME=STUDENT_RESULT&ARGUMENTS=-N123456789876543,-N000310,-N0,-N000000000000000,-N000000000000000,-N000000000000000,-N0,-N000000000000000",
    );
    expect(
      mainPageUrls.courseResultUrl,
      "www.endpoint.com/scripts/mgrqispi.dll?APPNAME=CampusNet&PRGNAME=COURSERESULTS&ARGUMENTS=-N123456789876543,-N000307,",
    );
    expect(
      mainPageUrls.monthlyScheduleUrl,
      "www.endpoint.com/scripts/mgrqispi.dll?APPNAME=CampusNet&PRGNAME=MONTH&ARGUMENTS=-N123456789876543,-N000031,-A",
    );
    expect(mainPageUrls.semesterCourseResultUrls, {});
  });

  test('UrlsFromMainPageExtract invalid html throws exception', () async {
    const extract = UrlsFromMainPageExtract();

    try {
      extract.parseMainPage("Lorem ipsum", DualisUrls(), "");
    } on ParseException {
      return;
    }

    fail("Exception not thrown!");
  });
}
