import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';
import 'package:dhbwstudentapp/dualis/model/exam.dart';
import 'package:dhbwstudentapp/dualis/model/exam_grade.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_scraper.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';

///
/// DualisScraper implementation which returns fake data
///
class FakeDataDualisScraper implements DualisScraper {
  bool _isLoggedIn = false;

  @override
  bool isLoggedIn() {
    return _isLoggedIn;
  }

  @override
  Future<List<DualisModule>> loadAllModules(
      [CancellationToken? cancellationToken,]) async {
    await Future.delayed(Duration(milliseconds: 200));

    return Future.value([
      DualisModule(
        "Module1",
        "Informatik",
        "1.0",
        "10",
        ExamState.Passed,
        "",
      ),
    ]);
  }

  @override
  Future<List<DualisExam>> loadModuleExams(
    String moduleDetailsUrl, [
    CancellationToken? cancellationToken,
  ]) async {
    await Future.delayed(Duration(milliseconds: 200));
    return Future.value([
      DualisExam(
        "Klausur",
        "Module1",
        ExamGrade.graded("1.0"),
        "1",
        "SoSe2020",
      ),
    ]);
  }

  @override
  Future<Schedule> loadMonthlySchedule(
    DateTime dateInMonth,
    CancellationToken cancellationToken,
  ) async {
    await Future.delayed(Duration(milliseconds: 200));
    return Future.value(Schedule.fromList([]));
  }

  @override
  Future<List<DualisModule>> loadSemesterModules(
    String? semesterName, [
    CancellationToken? cancellationToken,
  ]) async {
    await Future.delayed(Duration(milliseconds: 200));
    return Future.value([
      DualisModule(
        "Module1",
        "Informatik",
        "1.0",
        "10",
        ExamState.Passed,
        "",
      ),
    ]);
  }

  @override
  Future<List<DualisSemester>> loadSemesters(
      [CancellationToken? cancellationToken,]) async {
    await Future.delayed(Duration(milliseconds: 200));
    return Future.value([DualisSemester("SoSe2020", "", [])]);
  }

  @override
  Future<StudyGrades> loadStudyGrades(
      CancellationToken? cancellationToken,) async {
    await Future.delayed(Duration(milliseconds: 200));
    return Future.value(
      StudyGrades(
        1.5,
        1.5,
        210,
        10,
      ),
    );
  }

  @override
  Future<LoginResult> login(
    Credentials credentials,
    CancellationToken? cancellationToken,
  ) async {
    await Future.delayed(Duration(milliseconds: 200));
    _isLoggedIn = true;
    return Future.value(LoginResult.LoggedIn);
  }

  @override
  Future<LoginResult> loginWithPreviousCredentials(
      CancellationToken cancellationToken,) async {
    await Future.delayed(Duration(milliseconds: 200));
    _isLoggedIn = true;
    return Future.value(LoginResult.LoggedIn);
  }

  @override
  Future<void> logout(CancellationToken? cancellationToken) async {
    await Future.delayed(Duration(milliseconds: 200));
    _isLoggedIn = false;
  }

  @override
  void setLoginCredentials(Credentials? credentials) {
    // TODO: implement setLoginCredentials
  }
}
