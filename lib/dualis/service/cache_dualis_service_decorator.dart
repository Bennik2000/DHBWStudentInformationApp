import 'package:dhbwstudentapp/dualis/model/module.dart';
import 'package:dhbwstudentapp/dualis/model/semester.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';

///
/// Decorator class to cache the responses of a dualis service
///
class CacheDualisServiceDecorator extends DualisService {
  final DualisService _service;

  List<Module> _allModulesCached;
  List<String> _allSemesterNamesCached;
  Map<String, Semester> _semestersCached = {};
  StudyGrades _studyGradesCached;

  CacheDualisServiceDecorator(this._service);

  @override
  Future<bool> login(String username, String password) {
    return _service.login(username, password);
  }

  @override
  Future<List<Module>> queryAllModules() async {
    if (_allModulesCached != null) {
      return Future.value(_allModulesCached);
    }

    var allModules = await _service.queryAllModules();

    _allModulesCached = allModules;

    return allModules;
  }

  @override
  Future<Semester> querySemester(String name) async {
    if (_semestersCached.containsKey(name)) {
      return Future.value(_semestersCached[name]);
    }
    var semester = await _service.querySemester(name);

    _semestersCached[name] = semester;

    return semester;
  }

  @override
  Future<List<String>> querySemesterNames() async {
    if (_allSemesterNamesCached != null) {
      return Future.value(_allSemesterNamesCached);
    }

    var allSemesterNames = await _service.querySemesterNames();

    _allSemesterNamesCached = allSemesterNames;

    return allSemesterNames;
  }

  @override
  Future<StudyGrades> queryStudyGrades() async {
    if (_studyGradesCached != null) {
      return Future.value(_studyGradesCached);
    }

    var studyGrades = await _service.queryStudyGrades();

    _studyGradesCached = studyGrades;

    return studyGrades;
  }

  void clearCache() {
    _allModulesCached = null;
    _allSemesterNamesCached = null;
    _semestersCached = {};
    _studyGradesCached = null;
  }
}
