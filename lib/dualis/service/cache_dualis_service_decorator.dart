import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';
import 'package:dhbwstudentapp/dualis/model/module.dart';
import 'package:dhbwstudentapp/dualis/model/semester.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';

///
/// Decorator class to cache the responses of a dualis service
///
class CacheDualisServiceDecorator extends DualisService {
  final DualisService _service;

  List<Module>? _allModulesCached;
  List<String>? _allSemesterNamesCached;
  Map<String?, Semester> _semestersCached = {};
  StudyGrades? _studyGradesCached;

  CacheDualisServiceDecorator(this._service);

  @override
  Future<LoginResult> login(
    Credentials credentials, [
    CancellationToken? cancellationToken,
  ]) {
    return _service.login(credentials, cancellationToken);
  }

  @override
  Future<List<Module>> queryAllModules([
    CancellationToken? cancellationToken,
  ]) async {
    if (_allModulesCached != null) {
      return Future.value(_allModulesCached);
    }

    final allModules = await _service.queryAllModules(cancellationToken);

    _allModulesCached = allModules;

    return allModules;
  }

  @override
  Future<Semester> querySemester(
    String? name, [
    CancellationToken? cancellationToken,
  ]) async {
    if (_semestersCached.containsKey(name)) {
      return Future.value(_semestersCached[name]);
    }
    final semester = await _service.querySemester(name, cancellationToken);

    _semestersCached[name] = semester;

    return semester;
  }

  @override
  Future<List<String>> querySemesterNames([
    CancellationToken? cancellationToken,
  ]) async {
    if (_allSemesterNamesCached != null) {
      return Future.value(_allSemesterNamesCached);
    }

    final allSemesterNames = await _service.querySemesterNames(cancellationToken);

    _allSemesterNamesCached = allSemesterNames;

    return allSemesterNames;
  }

  @override
  Future<StudyGrades> queryStudyGrades([
    CancellationToken? cancellationToken,
  ]) async {
    if (_studyGradesCached != null) {
      return Future.value(_studyGradesCached);
    }

    final studyGrades = await _service.queryStudyGrades(cancellationToken);

    _studyGradesCached = studyGrades;

    return studyGrades;
  }

  void clearCache() {
    _allModulesCached = null;
    _allSemesterNamesCached = null;
    _semestersCached = {};
    _studyGradesCached = null;
  }

  @override
  Future<void> logout([
    CancellationToken? cancellationToken,
  ]) async {
    await _service.logout(cancellationToken);
    clearCache();
  }
}
