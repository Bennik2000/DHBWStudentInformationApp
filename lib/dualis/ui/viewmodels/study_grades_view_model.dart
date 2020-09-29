import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/common/util/cancelable_mutex.dart';
import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';
import 'package:dhbwstudentapp/dualis/model/module.dart';
import 'package:dhbwstudentapp/dualis/model/semester.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';

enum LoginState {
  LoggedOut,
  LoggingIn,
  LoggingOut,
  LoggedIn,
  LoginFailed,
}

class StudyGradesViewModel extends BaseViewModel {
  final DualisService _dualisService;

  final PreferencesProvider _preferencesProvider;

  LoginState _loginState = LoginState.LoggedOut;
  LoginState get loginState => _loginState;

  StudyGrades _studyGrades;
  StudyGrades get studyGrades => _studyGrades;
  final CancelableMutex _studyGradesCancellationToken = CancelableMutex();

  List<Module> _allModules;
  List<Module> get allModules => _allModules;
  final CancelableMutex _allModulesCancellationToken = CancelableMutex();

  List<String> _semesterNames;
  List<String> get allSemesterNames => _semesterNames;
  final CancelableMutex _semesterNamesCancellationToken = CancelableMutex();

  Semester _currentSemester;
  Semester get currentSemester => _currentSemester;
  final CancelableMutex _currentSemesterCancellationToken = CancelableMutex();

  String _currentSemesterName;
  String get currentSemesterName => _currentSemesterName;

  String _currentLoadingSemesterName;

  StudyGradesViewModel(this._preferencesProvider, this._dualisService);

  Future<bool> login(Credentials credentials) async {
    print("Logging into dualis...");

    bool success;

    try {
      var result = await _dualisService.login(
        credentials.username,
        credentials.password,
      );

      success = result == LoginResult.LoggedIn;
    } on OperationCancelledException catch (_) {
      success = false;
    }

    _loginState = success ? LoginState.LoggedIn : LoginState.LoginFailed;

    notifyListeners("loginState");

    if (!success) {
      print("Login failed!");
      return false;
    }

    print("Login successful");

    loadStudyGrades();
    loadSemesterNames();
    loadAllModules();

    return true;
  }

  Future<void> clearCredentials() async {
    await _preferencesProvider.clearDualisCredentials();
    await _preferencesProvider.setStoreDualisCredentials(false);
  }

  Future<Credentials> loadCredentials() async {
    return await _preferencesProvider.loadDualisCredentials();
  }

  Future<void> saveCredentials(Credentials credentials) async {
    await _preferencesProvider.storeDualisCredentials(credentials);
    await _preferencesProvider.setStoreDualisCredentials(true);
  }

  Future<bool> getDoSaveCredentials() {
    return _preferencesProvider.getStoreDualisCredentials();
  }

  Future<void> loadStudyGrades() async {
    if (_studyGrades != null) return Future.value();

    print("Loading study grades...");

    await _studyGradesCancellationToken.acquireAndCancelOther();

    try {
      _studyGrades = await _dualisService
          .queryStudyGrades(_studyGradesCancellationToken.token);

      print("Loaded study grades");
    } on OperationCancelledException catch (_) {
      print("Loading study grades cancelled");
    } finally {
      _studyGradesCancellationToken.release();
    }

    notifyListeners("studyGrades");
  }

  Future<void> loadAllModules() async {
    if (_allModules != null) return Future.value();

    print("Loading all modules...");

    await _allModulesCancellationToken.acquireAndCancelOther();

    try {
      _allModules = await _dualisService.queryAllModules(
        _allModulesCancellationToken.token,
      );

      print("Loaded all modules");
    } on OperationCancelledException catch (_) {
      print("Loading all modules cancelled");
    } finally {
      _allModulesCancellationToken.release();
    }

    notifyListeners("allModules");
  }

  Future<void> loadSemester(String semesterName) async {
    if (_currentSemester != null && _currentSemesterName == semesterName)
      return Future.value();

    if (_currentLoadingSemesterName == semesterName) return Future.value();

    await _preferencesProvider.setLastViewedSemester(semesterName);

    _currentLoadingSemesterName = semesterName;
    _currentSemesterName = semesterName;
    _currentSemester = null;
    notifyListeners("currentSemesterName");
    notifyListeners("currentSemester");

    print("Loading semester $semesterName...");

    await _currentSemesterCancellationToken.acquireAndCancelOther();

    try {
      _currentSemester = await _dualisService.querySemester(
        semesterName,
        _currentSemesterCancellationToken.token,
      );

      print("Loaded semester $semesterName");
    } on OperationCancelledException catch (_) {
      print("Loading semester $semesterName cancelled");
    } finally {
      _currentSemesterCancellationToken.release();
    }

    notifyListeners("currentSemester");
  }

  Future<void> loadSemesterNames() async {
    if (_semesterNames != null) return Future.value();

    print("Loading semester names...");

    await _semesterNamesCancellationToken.acquireAndCancelOther();

    try {
      _semesterNames = await _dualisService.querySemesterNames(
        _semesterNamesCancellationToken.token,
      );

      print("Loaded semester names");
    } on OperationCancelledException catch (_) {
      print("Loading semester names cancelled");
    } finally {
      _semesterNamesCancellationToken.release();
    }

    notifyListeners("semesterNames");

    await _loadInitialSemester();
  }

  Future _loadInitialSemester() async {
    if (_semesterNames == null) return;
    if (_semesterNames.isEmpty) return;

    var lastViewedSemester = await _preferencesProvider.getLastViewedSemester();

    if (_semesterNames.contains(lastViewedSemester)) {
      loadSemester(lastViewedSemester);
    } else {
      loadSemester(_semesterNames.first);
    }
  }

  Future<void> logout() async {
    print("Logging out...");

    _loginState = LoginState.LoggingOut;
    notifyListeners("loginState");

    _semesterNamesCancellationToken.cancel();
    _currentSemesterCancellationToken.cancel();
    _allModulesCancellationToken.cancel();
    _studyGradesCancellationToken.cancel();

    await _dualisService.logout();

    _loginState = LoginState.LoggedOut;
    _studyGrades = null;
    _allModules = null;
    _semesterNames = null;
    _currentSemester = null;
    _currentSemesterName = null;
    _currentLoadingSemesterName = null;

    notifyListeners();

    print("Logged out");
  }
}
