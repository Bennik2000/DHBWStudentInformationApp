import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';
import 'package:dhbwstudentapp/dualis/service/session.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/access_denied_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/all_modules_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/exams_from_module_details_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/login_redirect_url_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/modules_from_course_result_page_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/semesters_from_course_result_page_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/study_grades_from_student_results_page_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/timeout_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/urls_from_main_page_extract.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';
import 'package:http/http.dart';

class DualisScraper {
  static const String dualisEndpoint = "https://dualis.dhbw.de";

  String username;
  String password;

  DualisUrls dualisUrls;
  Session session;

  Future<LoginResult> login(
    String username,
    String password, [
    CancellationToken cancellationToken,
  ]) async {
    username = username ?? this.username;
    password = password ?? this.password;

    this.username = username;
    this.password = password;

    dualisUrls = DualisUrls();
    session = Session();

    var loginResponse = await _makeLoginRequest(
      username,
      password,
      cancellationToken,
    );

    if (loginResponse == null ||
        loginResponse.statusCode != 200 ||
        !loginResponse.headers.containsKey("refresh"))
      return LoginResult.LoginFailed;

    // TODO: Test for login failed page

    var redirectUrl = LoginRedirectUrlExtract().getUrlFromHeader(
      loginResponse.headers['refresh'],
      dualisEndpoint,
    );

    if (redirectUrl == null) return LoginResult.LoginFailed;

    var redirectPage = await session.get(
      redirectUrl,
      cancellationToken,
    );

    dualisUrls.mainPageUrl = LoginRedirectUrlExtract().readRedirectUrl(
      redirectPage,
      dualisEndpoint,
    );

    if (dualisUrls.mainPageUrl == null) return LoginResult.LoginFailed;

    var mainPage = await session.get(
      dualisUrls.mainPageUrl,
      cancellationToken,
    );

    UrlsFromMainPageExtract().parseMainPage(
      mainPage,
      dualisUrls,
      dualisEndpoint,
    );

    return LoginResult.LoggedIn;
  }

  Future<Response> _makeLoginRequest(
    String user,
    String password, [
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
      var loginResponse = await session.rawPost(
        loginUrl,
        data,
        cancellationToken,
      );
      return loginResponse;
    } on ServiceRequestFailed {
      return null;
    }
  }

  Future<List<DualisModule>> loadAllModules([
    CancellationToken cancellationToken,
  ]) async {
    var allModulesPageResponse = await _authenticatedGet(
      dualisUrls.studentResultsUrl,
      cancellationToken,
    );

    return AllModulesExtract().extractAllModules(allModulesPageResponse);
  }

  Future<List<DualisExam>> loadModuleExams(
    String moduleDetailsUrl, [
    CancellationToken cancellationToken,
  ]) async {
    var detailsResponse = await _authenticatedGet(
      moduleDetailsUrl,
      cancellationToken,
    );

    return ExamsFromModuleDetailsExtract().extractExamsFromModuleDetails(
      detailsResponse,
    );
  }

  Future<List<DualisSemester>> loadSemesters([
    CancellationToken cancellationToken,
  ]) async {
    var courseResultsResponse = await _authenticatedGet(
      dualisUrls.courseResultUrl,
      cancellationToken,
    );

    var semesters = SemestersFromCourseResultPageExtract()
        .extractSemestersFromCourseResults(
      courseResultsResponse,
      dualisEndpoint,
    );

    for (var semester in semesters) {
      dualisUrls.semesterCourseResultUrls[semester.semesterName] =
          semester.semesterCourseResultsUrl;
    }

    return semesters;
  }

  Future<List<DualisModule>> loadSemesterModules(
    String semesterName, [
    CancellationToken cancellationToken,
  ]) async {
    var coursePage = await _authenticatedGet(
      dualisUrls.semesterCourseResultUrls[semesterName],
      cancellationToken,
    );

    return ModulesFromCourseResultPageExtract()
        .extractModulesFromCourseResultPage(coursePage, dualisEndpoint);
  }

  Future<StudyGrades> loadStudyGrades(
    CancellationToken cancellationToken,
  ) async {
    var studentsResultsPage = await _authenticatedGet(
      dualisUrls.studentResultsUrl,
      cancellationToken,
    );

    return StudyGradesFromStudentResultsPageExtract()
        .extractStudyGradesFromStudentsResultsPage(studentsResultsPage);
  }

  Future<void> logout([
    CancellationToken cancellationToken,
  ]) async {
    var logoutRequest = session.get(dualisUrls.logoutUrl, cancellationToken);

    dualisUrls = null;
    session = null;

    await logoutRequest;
  }

  Future<String> _authenticatedGet(
    String url,
    CancellationToken cancellationToken,
  ) async {
    var result = await session.get(url, cancellationToken);

    if (TimeoutExtract().isTimeoutErrorPage(result) ||
        AccessDeniedExtract().isAccessDeniedPage(result)) {
      var loginResult = await login(username, password);

      if (loginResult == LoginResult.LoggedIn) {
        result = await session.get(url, cancellationToken);
      } else {
        result = null;
      }
    }

    cancellationToken?.throwIfCancelled();

    return result;
  }
}
