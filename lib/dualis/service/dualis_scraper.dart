import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';
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
  final DualisAuthentication _dualisAuthentication = DualisAuthentication();
  DualisUrls get _dualisUrls => _dualisAuthentication.dualisUrls;

  Future<List<DualisModule>> loadAllModules([
    CancellationToken? cancellationToken,
  ]) async {
    final allModulesPageResponse = await _dualisAuthentication.authenticatedGet(
      _dualisUrls.studentResultsUrl!,
      cancellationToken,
    );

    return AllModulesExtract().extractAllModules(allModulesPageResponse);
  }

  Future<List<DualisExam>> loadModuleExams(
    String moduleDetailsUrl, [
    CancellationToken? cancellationToken,
  ]) async {
    final detailsResponse = await _dualisAuthentication.authenticatedGet(
      moduleDetailsUrl,
      cancellationToken,
    );

    return ExamsFromModuleDetailsExtract().extractExamsFromModuleDetails(
      detailsResponse,
    );
  }

  Future<List<DualisSemester>> loadSemesters([
    CancellationToken? cancellationToken,
  ]) async {
    final courseResultsResponse = await _dualisAuthentication.authenticatedGet(
      _dualisUrls.courseResultUrl!,
      cancellationToken,
    );

    final semesters = SemestersFromCourseResultPageExtract()
        .extractSemestersFromCourseResults(
      courseResultsResponse,
      dualisEndpoint,
    );

    for (final semester in semesters) {
      _dualisUrls.semesterCourseResultUrls[semester.semesterName] =
          semester.semesterCourseResultsUrl;
    }

    return semesters;
  }

  Future<List<DualisModule?>> loadSemesterModules(
    String? semesterName, [
    CancellationToken? cancellationToken,
  ]) async {
    final coursePage = await _dualisAuthentication.authenticatedGet(
      _dualisUrls.semesterCourseResultUrls[semesterName!]!,
      cancellationToken,
    );

    return ModulesFromCourseResultPageExtract()
        .extractModulesFromCourseResultPage(coursePage, dualisEndpoint);
  }

  Future<StudyGrades> loadStudyGrades(
    CancellationToken? cancellationToken,
  ) async {
    final studentsResultsPage = await _dualisAuthentication.authenticatedGet(
      _dualisUrls.studentResultsUrl!,
      cancellationToken,
    );

    return StudyGradesFromStudentResultsPageExtract()
        .extractStudyGradesFromStudentsResultsPage(studentsResultsPage);
  }

  Future<Schedule> loadMonthlySchedule(
    DateTime dateInMonth,
    CancellationToken cancellationToken,
  ) async {
    final requestUrl =
        "${_dualisUrls.monthlyScheduleUrl}01.${dateInMonth.month}.${dateInMonth.year}";

    final result = await _dualisAuthentication.authenticatedGet(
        requestUrl, cancellationToken,);

    final schedule = MonthlyScheduleExtract().extractScheduleFromMonthly(result);

    schedule.urls.add(dualisEndpoint);

    return schedule;
  }

  Future<LoginResult> login(
    Credentials credentials,
    CancellationToken? cancellationToken,
  ) {
    return _dualisAuthentication.login(credentials, cancellationToken);
  }

  Future<LoginResult> loginWithPreviousCredentials(
    CancellationToken cancellationToken,
  ) {
    return _dualisAuthentication
        .loginWithPreviousCredentials(cancellationToken);
  }

  Future<void> logout(CancellationToken? cancellationToken) {
    return _dualisAuthentication.logout(cancellationToken);
  }

  bool isLoggedIn() {
    return _dualisAuthentication.loginState == LoginResult.LoggedIn;
  }

  void setLoginCredentials(Credentials credentials) {
    _dualisAuthentication.setLoginCredentials(credentials);
  }
}
