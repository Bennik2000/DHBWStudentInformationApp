import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/dualis/model/exam.dart';
import 'package:dhbwstudentapp/dualis/model/module.dart';
import 'package:dhbwstudentapp/dualis/model/semester.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_scraper.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_session.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';

abstract class DualisService {
  Future<bool> login(
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

class DualisServiceImpl extends DualisService {
  final DualisScraper _dualisScraper = DualisScraper();

  DualisUrls _dualisUrls;
  DualisSession _session;

  @override
  Future<bool> login(
    String username,
    String password, [
    CancellationToken cancellationToken,
  ]) async {
    _session = await _dualisScraper.login(
      username,
      password,
      cancellationToken,
    );

    if (_session == null) return false;

    cancellationToken?.throwIfCancelled();

    _dualisUrls = await _dualisScraper.requestMainPage(
      _session,
      cancellationToken,
    );

    cancellationToken?.throwIfCancelled();

    return true;
  }

  @override
  Future<StudyGrades> queryStudyGrades([
    CancellationToken cancellationToken,
  ]) async {
    var studyGrades = await _dualisScraper.loadStudyGrades(
      _session,
      _dualisUrls.studentResultsUrl,
      cancellationToken,
    );

    return studyGrades;
  }

  @override
  Future<List<String>> querySemesterNames([
    CancellationToken cancellationToken,
  ]) async {
    var semesters = await _dualisScraper.loadSemesters(
      _session,
      _dualisUrls,
      cancellationToken,
    );

    var names = <String>[];

    for (var semester in semesters) {
      names.add(semester.semesterName);

      _dualisUrls.semesterCourseResultUrls[semester.semesterName] =
          semester.semesterCourseResultsUrl;
    }

    return names;
  }

  @override
  Future<List<Module>> queryAllModules([
    CancellationToken cancellationToken,
  ]) async {
    var dualisModules = await _dualisScraper.loadAllModules(
      _session,
      _dualisUrls.studentResultsUrl,
      cancellationToken,
    );

    var modules = <Module>[];

    for (var module in dualisModules) {
      cancellationToken?.throwIfCancelled();

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
      _session,
      _dualisUrls.semesterCourseResultUrls[name],
      cancellationToken,
    );

    var modules = <Module>[];

    for (var dualisModule in semesterModules) {
      cancellationToken?.throwIfCancelled();

      var moduleExams = await _dualisScraper.loadModuleExams(
        dualisModule.detailsUrl,
        _session,
        cancellationToken,
      );

      var exams = <Exam>[];

      for (var exam in moduleExams) {
        exams.add(Exam(
          exam.name,
          exam.grade,
          ExamState.Failed,
          exam.semester,
        ));
      }

      var module = Module(
        exams,
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
    await _dualisScraper.logout(
      _session,
      _dualisUrls,
      cancellationToken,
    );

    _session = null;
    _dualisUrls = null;
  }
}
