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

    if (_session == null) return false;

    _dualisUrls = await _dualisScraper.requestMainPage(_session);

    return true;
  }

  @override
  Future<StudyGrades> queryStudyGrades() async {
    var studyGrades = await _dualisScraper.loadStudyGrades(
      _session,
      _dualisUrls.studentResultsUrl,
    );

    return studyGrades;
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
  Future<List<Module>> queryAllModules() async {
    var dualisModules = await _dualisScraper.loadAllModules(
      _session,
      _dualisUrls.studentResultsUrl,
    );

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
}
