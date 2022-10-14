import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_scraper.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:dhbwstudentapp/dualis/service/fake_data_dualis_scraper.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';

///
/// This DualisScraper decorator allows to enter specific fake account
/// information in order to get beyond the Dualis login without having a
/// dualis account.
/// Background: The AppStore review process needs login credentials to every
/// area of the app.
///
class FakeAccountDualisScraperDecorator implements DualisScraper {
  static const _credentials = Credentials("fakeAccount@domain.de", "Passw0rd");

  final DualisScraper _fakeDualisScraper = FakeDataDualisScraper();
  final DualisScraper _originalDualisScraper;

  late DualisScraper _currentDualisScraper;

  FakeAccountDualisScraperDecorator(
    this._originalDualisScraper,
  );

  @override
  bool isLoggedIn() {
    return _currentDualisScraper.isLoggedIn();
  }

  @override
  Future<List<DualisModule>> loadAllModules(
      [CancellationToken? cancellationToken,]) {
    return _currentDualisScraper.loadAllModules();
  }

  @override
  Future<List<DualisExam>> loadModuleExams(
    String moduleDetailsUrl, [
    CancellationToken? cancellationToken,
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
  Future<List<DualisModule?>> loadSemesterModules(
    String? semesterName, [
    CancellationToken? cancellationToken,
  ]) {
    return _currentDualisScraper.loadSemesterModules(
      semesterName,
      cancellationToken,
    );
  }

  @override
  Future<List<DualisSemester>> loadSemesters(
      [CancellationToken? cancellationToken,]) {
    return _currentDualisScraper.loadSemesters(cancellationToken);
  }

  @override
  Future<StudyGrades> loadStudyGrades(CancellationToken? cancellationToken) {
    return _currentDualisScraper.loadStudyGrades(cancellationToken);
  }

  @override
  Future<LoginResult> login(
    Credentials credentials,
    CancellationToken? cancellationToken,
  ) {
    if (credentials == _credentials) {
      _currentDualisScraper = _fakeDualisScraper;
    } else {
      _currentDualisScraper = _originalDualisScraper;
    }
    return _currentDualisScraper.login(
      credentials,
      cancellationToken,
    );
  }

  @override
  Future<LoginResult> loginWithPreviousCredentials(
      CancellationToken cancellationToken,) {
    return _currentDualisScraper.loginWithPreviousCredentials(
      cancellationToken,
    );
  }

  @override
  Future<void> logout(CancellationToken? cancellationToken) {
    return _currentDualisScraper.logout(
      cancellationToken,
    );
  }

  @override
  void setLoginCredentials(Credentials credentials) {
    if (credentials == _credentials) {
      _currentDualisScraper = _fakeDualisScraper;
    } else {
      _currentDualisScraper = _originalDualisScraper;
    }

    return _currentDualisScraper.setLoginCredentials(credentials);
  }
}
