import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_scraper.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:dhbwstudentapp/dualis/service/fake_data_dualis_scraper.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';

class FakeAccountDualisScraperDecorator implements DualisScraper {
  final fakeUsername = "fakeAccount@domain.de";
  final fakePassword = "Passw0rd";

  final DualisScraper _fakeDualisScraper = FakeDataDualisScraper();
  final DualisScraper _originalDualisScraper;

  DualisScraper _currentDualisScraper;

  FakeAccountDualisScraperDecorator(
    this._originalDualisScraper,
  );

  @override
  bool isLoggedIn() {
    return _currentDualisScraper.isLoggedIn();
  }

  @override
  Future<List<DualisModule>> loadAllModules(
      [CancellationToken cancellationToken]) {
    return _currentDualisScraper.loadAllModules();
  }

  @override
  Future<List<DualisExam>> loadModuleExams(
    String moduleDetailsUrl, [
    CancellationToken cancellationToken,
  ]) {
    return _currentDualisScraper.loadModuleExams(
      moduleDetailsUrl,
      cancellationToken,
    );
  }

  @override
  Future<Schedule> loadMonthlySchedule(
    DateTime dateInMonth,
    CancellationToken cancellationToken,
  ) {
    return _currentDualisScraper.loadMonthlySchedule(
      dateInMonth,
      cancellationToken,
    );
  }

  @override
  Future<List<DualisModule>> loadSemesterModules(
    String semesterName, [
    CancellationToken cancellationToken,
  ]) {
    return _currentDualisScraper.loadSemesterModules(
      semesterName,
      cancellationToken,
    );
  }

  @override
  Future<List<DualisSemester>> loadSemesters(
      [CancellationToken cancellationToken]) {
    return _currentDualisScraper.loadSemesters(cancellationToken);
  }

  @override
  Future<StudyGrades> loadStudyGrades(CancellationToken cancellationToken) {
    return _currentDualisScraper.loadStudyGrades(cancellationToken);
  }

  @override
  Future<LoginResult> login(
    String username,
    String password,
    CancellationToken cancellationToken,
  ) {
    if (username == fakeUsername && password == fakePassword) {
      _currentDualisScraper = _fakeDualisScraper;
    } else {
      _currentDualisScraper = _originalDualisScraper;
    }
    return _currentDualisScraper.login(
      username,
      password,
      cancellationToken,
    );
  }

  @override
  Future<LoginResult> loginWithPreviousCredentials(
      CancellationToken cancellationToken) {
    return _currentDualisScraper.loginWithPreviousCredentials(
      cancellationToken,
    );
  }

  @override
  Future<void> logout(CancellationToken cancellationToken) {
    return _currentDualisScraper.logout(
      cancellationToken,
    );
  }

  @override
  void setLoginCredentials(String username, String password) {
    if (username == fakeUsername && password == fakePassword) {
      _currentDualisScraper = _fakeDualisScraper;
    } else {
      _currentDualisScraper = _originalDualisScraper;
    }

    return _currentDualisScraper.setLoginCredentials(
      username,
      password,
    );
  }
}
