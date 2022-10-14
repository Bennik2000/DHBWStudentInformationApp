import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';
import 'package:dhbwstudentapp/dualis/model/exam.dart';
import 'package:dhbwstudentapp/dualis/model/module.dart';
import 'package:dhbwstudentapp/dualis/model/semester.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_scraper.dart';

abstract class DualisService {
  Future<LoginResult> login(
    Credentials credentials, [
    CancellationToken? cancellationToken,
  ]);

  Future<StudyGrades> queryStudyGrades([
    CancellationToken? cancellationToken,
  ]);

  Future<List<String>> querySemesterNames([
    CancellationToken? cancellationToken,
  ]);

  Future<List<Module>> queryAllModules([
    CancellationToken? cancellationToken,
  ]);

  Future<Semester> querySemester(
    String? name, [
    CancellationToken? cancellationToken,
  ]);

  Future<void> logout([
    CancellationToken? cancellationToken,
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
    Credentials credentials, [
    CancellationToken? cancellationToken,
  ]) async {
    return  _dualisScraper.login(
      credentials,
      cancellationToken,
    );
  }

  @override
  Future<StudyGrades> queryStudyGrades([
    CancellationToken? cancellationToken,
  ]) async {
    return  _dualisScraper.loadStudyGrades(cancellationToken);
  }

  @override
  Future<List<String>> querySemesterNames([
    CancellationToken? cancellationToken,
  ]) async {
    final semesters = await _dualisScraper.loadSemesters(cancellationToken);

    final names = <String>[];

    for (final semester in semesters) {
      names.add(semester.semesterName);
    }

    return names;
  }

  @override
  Future<List<Module>> queryAllModules([
    CancellationToken? cancellationToken,
  ]) async {
    final dualisModules = await _dualisScraper.loadAllModules(cancellationToken);

    final modules = <Module>[];
    for (final module in dualisModules) {
      modules.add(Module(
        <Exam>[],
        module.id,
        module.name,
        module.credits,
        module.finalGrade,
        module.state,
      ),);
    }
    return modules;
  }

  @override
  Future<Semester> querySemester(
    String? name, [
    CancellationToken? cancellationToken,
  ]) async {
    final semesterModules = await _dualisScraper.loadSemesterModules(
      name,
      cancellationToken,
    );

    final modules = <Module>[];

    for (final dualisModule in semesterModules) {
      final moduleExams = await _dualisScraper.loadModuleExams(
        dualisModule!.detailsUrl!,
        cancellationToken,
      );

      final module = Module(
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
    CancellationToken? cancellationToken,
  ]) async {
    await _dualisScraper.logout(cancellationToken);
  }
}
