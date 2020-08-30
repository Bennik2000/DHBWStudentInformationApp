import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_session.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/all_modules_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/exams_from_module_details_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/login_redirect_url_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/modules_from_course_result_page_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/semesters_from_course_result_page_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/study_grades_from_student_results_page_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/urls_from_main_page_extract.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';
import 'package:http/http.dart';

class DualisScraper {
  static final String dualisEndpoint = "https://dualis.dhbw.de";

  Future<DualisSession> login(
    String user,
    String password, [
    CancellationToken cancellationToken,
  ]) async {
    var session = DualisSession();

    var loginResponse = await _makeLoginRequest(
      user,
      password,
      session,
      cancellationToken,
    );

    if (loginResponse == null) return null;
    if (loginResponse.statusCode != 200) return null;
    if (!loginResponse.headers.containsKey("refresh")) return null;

    var refreshHeader = loginResponse.headers['refresh'];
    var refreshUrl = LoginRedirectUrlExtract().getUrlFromHeader(
      refreshHeader,
      dualisEndpoint,
    );

    if (refreshUrl == null) return null;

    var redirectResponse = await session.get(
      refreshUrl,
      cancellationToken,
    );

    var redirectUrl = LoginRedirectUrlExtract().readRedirectUrl(
      redirectResponse,
      dualisEndpoint,
    );

    if (redirectUrl == null) return null;

    session.mainPageUrl = redirectUrl;
    return session;
  }

  Future<Response> _makeLoginRequest(
    String user,
    String password,
    DualisSession session, [
    CancellationToken cancellationToken,
  ]) async {
    var loginUrl = dualisEndpoint + "/scripts/mgrqispi.dll";

    var data = {
      "usrname": user,
      "pass": password,
      "APPNAME": "CampusNet",
      "PRGNAME": "LOGINCHECK",
      "ARGUMENTS": "clino,usrname,pass,menuno,menu_type,browser,platform",
      "clino": "000000000000001",
      "menuno": "000324",
      "menu_type": "classic",
    };

    try {
      var loginResponse = await session.post(
        loginUrl,
        data,
        cancellationToken,
      );
      return loginResponse;
    } on ServiceRequestFailed {
      return null;
    }
  }

  Future<DualisUrls> requestMainPage(
    DualisSession session, [
    CancellationToken cancellationToken,
  ]) async {
    var mainPageResponse = await session.get(
      session.mainPageUrl,
      cancellationToken,
    );

    return UrlsFromMainPageExtract().parseMainPage(
      mainPageResponse,
      dualisEndpoint,
    );
  }

  Future<List<DualisModule>> loadAllModules(
    DualisSession session,
    String studentResultsUrl, [
    CancellationToken cancellationToken,
  ]) async {
    var allModulesPageResponse = await session.get(
      studentResultsUrl,
      cancellationToken,
    );

    return AllModulesExtract().extractAllModules(allModulesPageResponse);
  }

  Future<List<DualisExam>> loadModuleExams(
    String moduleDetailsUrl,
    DualisSession session, [
    CancellationToken cancellationToken,
  ]) async {
    var detailsResponse = await session.get(
      moduleDetailsUrl,
      cancellationToken,
    );

    return ExamsFromModuleDetailsExtract().extractExamsFromModuleDetails(
      detailsResponse,
    );
  }

  Future<List<DualisSemester>> loadSemesters(
    DualisSession session,
    DualisUrls mainPage, [
    CancellationToken cancellationToken,
  ]) async {
    var courseResultsResponse = await session.get(
      mainPage.courseResultUrl,
      cancellationToken,
    );

    return SemestersFromCourseResultPageExtract()
        .extractSemestersFromCourseResults(
      courseResultsResponse,
      dualisEndpoint,
    );
  }

  Future<List<DualisModule>> loadSemesterModules(
    DualisSession session,
    String semesterCourseResultsUrl, [
    CancellationToken cancellationToken,
  ]) async {
    var coursePage = await session.get(
      semesterCourseResultsUrl,
      cancellationToken,
    );

    return ModulesFromCourseResultPageExtract()
        .extractModulesFromCourseResultPage(coursePage, dualisEndpoint);
  }

  Future<StudyGrades> loadStudyGrades(
    DualisSession session,
    String studentResultsUrl, [
    CancellationToken cancellationToken,
  ]) async {
    var studentsResultsPage = await session.get(
      studentResultsUrl,
      cancellationToken,
    );

    return StudyGradesFromStudentResultsPageExtract()
        .extractStudyGradesFromStudentsResultsPage(studentsResultsPage);
  }

  Future<void> logout(
    DualisSession session,
    DualisUrls urls, [
    CancellationToken cancellationToken,
  ]) async {
    await session.get(urls.logoutUrl, cancellationToken);
  }
}
