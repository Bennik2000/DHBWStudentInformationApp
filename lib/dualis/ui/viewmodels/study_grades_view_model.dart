import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';
import 'package:dhbwstudentapp/dualis/model/module.dart';
import 'package:dhbwstudentapp/dualis/model/semester.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';

enum LoginState {
  LoggedOut,
  LoggingIn,
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

  List<Module> _allModules;
  List<Module> get allModules => _allModules;

  List<String> _semesterNames;
  List<String> get allSemesterNames => _semesterNames;

  Semester _currentSemester;
  Semester get currentSemester => _currentSemester;

  String _currentSemesterName;
  String get currentSemesterName => _currentSemesterName;

  StudyGradesViewModel(this._preferencesProvider, this._dualisService);

  Future<bool> login(Credentials credentials) async {
    print("Logging into dualis...");

    bool success = await _dualisService.login(
      credentials.username,
      credentials.password,
    );

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

    _studyGrades = await _dualisService.queryStudyGrades();

    print("Loaded study grades");

    notifyListeners("studyGrades");
  }

  Future<void> loadAllModules() async {
    if (_allModules != null) return Future.value();

    print("Loading all modules...");

    _allModules = await _dualisService.queryAllModules();

    print("Loaded all modules");

    notifyListeners("allModules");
  }

  Future<void> loadSemester(String semesterName) async {
    if (_currentSemester != null && _currentSemesterName == semesterName)
      return Future.value();

    _currentSemesterName = semesterName;
    _currentSemester = null;
    notifyListeners("currentSemesterName");
    notifyListeners("currentSemester");

    print("Loading semester $semesterName...");

    _currentSemester = await _dualisService.querySemester(semesterName);

    print("Loaded semester $semesterName");

    notifyListeners("currentSemester");
  }

  Future<void> loadSemesterNames() async {
    if (_semesterNames != null) return Future.value();

    print("Loading semester names...");

    _semesterNames = await _dualisService.querySemesterNames();

    print("Loaded semester names");

    notifyListeners("semesterNames");

    if ((_semesterNames?.length ?? 0) > 0) {
      loadSemester(_semesterNames.first);
    }
  }
}
