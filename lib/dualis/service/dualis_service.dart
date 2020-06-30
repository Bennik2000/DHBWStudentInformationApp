import 'package:dhbwstudentapp/dualis/model/exam.dart';
import 'package:dhbwstudentapp/dualis/model/module.dart';
import 'package:dhbwstudentapp/dualis/model/semester.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_scraper.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_session.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';

abstract class DualisService {
  Future<bool> login(String username, String password);

  Future<StudyGrades> queryStudyGrades();

  Future<List<String>> querySemesterNames();

  Future<List<Module>> queryAllModules();

  Future<Semester> querySemester(String name);
}

class DualisServiceImpl extends DualisService {
  final DualisScraper _dualisScraper = DualisScraper();

  DualisUrls _dualisUrls;
  DualisSession _session;

  @override
  Future<bool> login(String username, String password) async {
    _session = await _dualisScraper.login(username, password);
    _dualisUrls = await _dualisScraper.requestMainPage(_session);
    return _session != null;
  }

  @override
  Future<StudyGrades> queryStudyGrades() async {
    // TODO:

    await Future.delayed(Duration(seconds: 1));
    return StudyGrades(0.0, 0.0, 0, 0);
  }

  @override
  Future<List<String>> querySemesterNames() async {
    var semesters = await _dualisScraper.loadSemesters(
      _session,
      _dualisUrls,
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
  Future<List<Module>> queryAllModules() {
    // TODO:
    return Future.value([]);
  }

  @override
  Future<Semester> querySemester(String name) async {
    var semesterModules = await _dualisScraper.loadSemesterModules(
      _session,
      _dualisUrls.semesterCourseResultUrls[name],
    );

    var modules = <Module>[];

    for (var dualisModule in semesterModules) {
      var moduleExams = await _dualisScraper.loadModuleExams(
        dualisModule.detailsUrl,
        _session,
      );

      var exams = <Exam>[];

      for (var exam in moduleExams) {
        if (exam.semester != name) continue;

        exams.add(Exam(
          exam.name,
          exam.grade,
          ExamState.Failed,
        ));
      }

      var module = Module(
        exams,
        dualisModule.id,
        dualisModule.name,
        dualisModule.credits,
        dualisModule.finalGrade,
      );

      modules.add(module);
    }

    return Semester(name, modules);
  }
}

class AuthenticationFailedException implements Exception {}
