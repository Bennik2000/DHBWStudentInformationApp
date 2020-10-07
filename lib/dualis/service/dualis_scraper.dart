import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_authentication.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/monthly_schedule_extract.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/all_modules_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/exams_from_module_details_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/modules_from_course_result_page_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/semesters_from_course_result_page_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/study_grades_from_student_results_page_extract.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';

///
/// Provides one single class to access the dualis api.
///
class DualisScraper {
  DualisAuthentication _dualisAuthentication = DualisAuthentication();
  DualisUrls get _dualisUrls => _dualisAuthentication.dualisUrls;

  Future<List<DualisModule>> loadAllModules([
    CancellationToken cancellationToken,
  ]) async {
    var allModulesPageResponse = await _dualisAuthentication.authenticatedGet(
      _dualisUrls.studentResultsUrl,
      cancellationToken,
    );

    return AllModulesExtract().extractAllModules(allModulesPageResponse);
  }

  Future<List<DualisExam>> loadModuleExams(
    String moduleDetailsUrl, [
    CancellationToken cancellationToken,
  ]) async {
    var detailsResponse = await _dualisAuthentication.authenticatedGet(
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
    var courseResultsResponse = await _dualisAuthentication.authenticatedGet(
      _dualisUrls.courseResultUrl,
      cancellationToken,
    );

    var semesters = SemestersFromCourseResultPageExtract()
        .extractSemestersFromCourseResults(
      courseResultsResponse,
      dualisEndpoint,
    );

    for (var semester in semesters) {
      _dualisUrls.semesterCourseResultUrls[semester.semesterName] =
          semester.semesterCourseResultsUrl;
    }

    return semesters;
  }

  Future<List<DualisModule>> loadSemesterModules(
    String semesterName, [
    CancellationToken cancellationToken,
  ]) async {
    var coursePage = await _dualisAuthentication.authenticatedGet(
      _dualisUrls.semesterCourseResultUrls[semesterName],
      cancellationToken,
    );

    return ModulesFromCourseResultPageExtract()
        .extractModulesFromCourseResultPage(coursePage, dualisEndpoint);
  }

  Future<StudyGrades> loadStudyGrades(
    CancellationToken cancellationToken,
  ) async {
    var studentsResultsPage = await _dualisAuthentication.authenticatedGet(
      _dualisUrls.studentResultsUrl,
      cancellationToken,
    );

    return StudyGradesFromStudentResultsPageExtract()
        .extractStudyGradesFromStudentsResultsPage(studentsResultsPage);
  }

  Future<Schedule> loadMonthlySchedule(
    DateTime dateInMonth,
    CancellationToken cancellationToken,
  ) async {
    var requestUrl =
        "${_dualisUrls.monthlyScheduleUrl}01.${dateInMonth.month}.${dateInMonth.year}";

    var result = await _dualisAuthentication.authenticatedGet(
        requestUrl, cancellationToken);

    var schedule = MonthlyScheduleExtract().extractScheduleFromMonthly(result);

    schedule.urls.add(dualisEndpoint);

    return schedule;
  }

  Future<LoginResult> login(
    String username,
    String password,
    CancellationToken cancellationToken,
  ) {
    return _dualisAuthentication.login(username, password, cancellationToken);
  }

  Future<LoginResult> loginWithPreviousCredentials(
    CancellationToken cancellationToken,
  ) {
    return _dualisAuthentication
        .loginWithPreviousCredentials(cancellationToken);
  }

  Future<void> logout(CancellationToken cancellationToken) {
    return _dualisAuthentication.logout(cancellationToken);
  }

  bool isLoggedIn() {
    return _dualisAuthentication.loginState == LoginResult.LoggedIn;
  }

  void setLoginCredentials(String username, String password) {
    _dualisAuthentication.setLoginCredentials(username, password);
  }
}
