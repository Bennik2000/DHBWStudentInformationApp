import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/dualis/model/exam.dart';
import 'package:dhbwstudentapp/dualis/model/module.dart';
import 'package:dhbwstudentapp/dualis/model/semester.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_scraper.dart';

abstract class DualisService {
  Future<LoginResult> login(
    String username,
    String password, [
    CancellationToken cancellationToken,
  ]);

  Future<StudyGrades> queryStudyGrades([
    CancellationToken cancellationToken,
  ]);

  Future<List<String>> querySemesterNames([
    CancellationToken cancellationToken,
  ]);

  Future<List<Module>> queryAllModules([
    CancellationToken cancellationToken,
  ]);

  Future<Semester> querySemester(
    String name, [
    CancellationToken cancellationToken,
  ]);

  Future<void> logout([
    CancellationToken cancellationToken,
  ]);
}

enum LoginResult {
  LoggedOut,
  LoggedIn,
  WrongCredentials,
  LoginFailed,
}

class DualisServiceImpl extends DualisService {
  final DualisScraper _dualisScraper;

  DualisServiceImpl(this._dualisScraper);

  @override
  Future<LoginResult> login(
    String username,
    String password, [
    CancellationToken cancellationToken,
  ]) async {
    return await _dualisScraper.login(
      username,
      password,
      cancellationToken,
    );
  }

  @override
  Future<StudyGrades> queryStudyGrades([
    CancellationToken cancellationToken,
  ]) async {
    return await _dualisScraper.loadStudyGrades(cancellationToken);
  }

  @override
  Future<List<String>> querySemesterNames([
    CancellationToken cancellationToken,
  ]) async {
    var semesters = await _dualisScraper.loadSemesters(cancellationToken);

    var names = <String>[];

    for (var semester in semesters) {
      names.add(semester.semesterName);
    }

    return names;
  }

  @override
  Future<List<Module>> queryAllModules([
    CancellationToken cancellationToken,
  ]) async {
    var dualisModules = await _dualisScraper.loadAllModules(cancellationToken);

    var modules = <Module>[];
    for (var module in dualisModules) {
      modules.add(Module(
        <Exam>[],
        module.id,
        module.name,
        module.credits,
        module.finalGrade,
        module.state,
      ));
    }
    return modules;
  }

  @override
  Future<Semester> querySemester(
    String name, [
    CancellationToken cancellationToken,
  ]) async {
    var semesterModules = await _dualisScraper.loadSemesterModules(
      name,
      cancellationToken,
    );

    var modules = <Module>[];

    for (var dualisModule in semesterModules) {
      var moduleExams = await _dualisScraper.loadModuleExams(
        dualisModule.detailsUrl,
        cancellationToken,
      );

      var module = Module(
        moduleExams
            .map(
              (exam) => Exam(
                exam.name,
                exam.grade,
                ExamState.Failed,
                exam.semester,
              ),
            )
            .toList(),
        dualisModule.id,
        dualisModule.name,
        dualisModule.credits,
        dualisModule.finalGrade,
        dualisModule.state,
      );

      modules.add(module);
    }

    return Semester(name, modules);
  }

  @override
  Future<void> logout([
    CancellationToken cancellationToken,
  ]) async {
    await _dualisScraper.logout(cancellationToken);
  }
}
