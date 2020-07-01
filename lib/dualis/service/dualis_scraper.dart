import 'package:dhbwstudentapp/dualis/service/dualis_response_parser.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_session.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:http/http.dart';

class DualisScraper {
  static final String dualisEndpoint = "https://dualis.dhbw.de";

  final DualisResponseParser responseParser =
      DualisResponseParser(dualisEndpoint);

  Future<DualisSession> login(String user, String password) async {
    var session = DualisSession();

    var loginResponse = await _makeLoginRequest(user, password, session);
    if (loginResponse.statusCode != 200) return null;

    session.mainPageUrl = await _followLoginRedirect(loginResponse, session);

    return session;
  }

  Future<String> _followLoginRedirect(
    Response loginResponse,
    DualisSession session,
  ) async {
    var refreshHeader = loginResponse.headers['refresh'];
    var refreshUrl = responseParser.getUrlFromHeader(refreshHeader);

    var redirectResponse = await session.get(refreshUrl);

    var redirectUrl = responseParser.readRedirectUrl(redirectResponse.body);
    return redirectUrl;
  }

  Future<Response> _makeLoginRequest(
    String user,
    String password,
    DualisSession session,
  ) async {
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

    var loginResponse = await session.post(loginUrl, data);
    return loginResponse;
  }

  Future<DualisUrls> requestMainPage(DualisSession session) async {
    var mainPageResponse = await session.get(session.mainPageUrl);

    return responseParser.parseMainPage(mainPageResponse.body);
  }

  Future<List<DualisModule>> loadAllModules(
    DualisSession session,
    String studentResultsUrl,
  ) async {
    var allModulesPageResponse = await session.get(studentResultsUrl);

    return responseParser.extractAllModules(allModulesPageResponse.body);
  }

  Future<List<DualisExam>> loadModuleExams(
    String moduleDetailsUrl,
    DualisSession session,
  ) async {
    var detailsResponse = await session.get(moduleDetailsUrl);

    var exams =
        responseParser.extractExamsFromCoarsesDetails(detailsResponse.body);

    return exams;
  }

  Future<List<DualisSemester>> loadSemesters(
    DualisSession session,
    DualisUrls mainPage,
  ) async {
    var courseResultsResponse = await session.get(mainPage.courseResultUrl);

    var semesters = responseParser.extractSemestersFromCourseResults(
      courseResultsResponse.body,
    );

    return semesters;
  }

  Future<List<DualisModule>> loadSemesterModules(
    DualisSession session,
    String semesterCourseResultsUrl,
  ) async {
    var coursePage = await session.get(semesterCourseResultsUrl);

    var courses =
        responseParser.extractModulesFromCourseResultPage(coursePage.body);

    return courses;
  }
}
