import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/dualis/model/module.dart';
import 'package:dhbwstudentapp/dualis/model/semester.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/cache_dualis_service_decorator.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';

class StudyGradesViewModel extends BaseViewModel {
  final DualisService _dualisService = CacheDualisServiceDecorator(
    DualisServiceImpl(),
  );

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _loginFailed = false;
  bool get loginFailed => _loginFailed;

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

  Future<bool> login(String username, String password) async {
    print("Logging into dualis...");

    bool success;

    try {
      success = await _dualisService.login(username, password);
    } catch (ex, trace) {
      success = false;
      print("Exception while logging in: $ex $trace");
    }

    _loginFailed = !success;
    _isLoggedIn = success;

    notifyListeners("loginFailed");
    notifyListeners("isLoggedIn");

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

  Future<void> loadStudyGrades() async {
    if (_studyGrades != null) return Future.value();

    print("Loading study grades...");

    try {
      _studyGrades = await _dualisService.queryStudyGrades();
      print("Loaded study grades");
    } catch (ex, trace) {
      _studyGrades = null;
      print("Exception while loading study grades: $ex, $trace");
    }

    notifyListeners("studyGrades");
  }

  Future<void> loadAllModules() async {
    if (_allModules != null) return Future.value();

    print("Loading all modules...");

    try {
      _allModules = await _dualisService.queryAllModules();
      print("Loaded all modules");
    } catch (ex, trace) {
      _allModules = null;
      print("Exception while loading all modules: $ex, $trace");
    }

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

    try {
      _currentSemester = await _dualisService.querySemester(semesterName);
      print("Loaded semester $semesterName");
    } catch (ex, trace) {
      _currentSemester = null;
      print("Exception while loading semester ($semesterName): $ex, $trace");
    }

    notifyListeners("currentSemester");
  }

  Future<void> loadSemesterNames() async {
    if (_semesterNames != null) return Future.value();

    print("Loading semester names...");

    try {
      _semesterNames = await _dualisService.querySemesterNames();
      print("Loaded semester names");
    } catch (ex, trace) {
      _semesterNames = null;
      print("Exception while loading semester names: $ex, $trace");
    }

    notifyListeners("semesterNames");

    if ((_semesterNames?.length ?? 0) > 0) {
      loadSemester(_semesterNames.first);
    }
  }
}
