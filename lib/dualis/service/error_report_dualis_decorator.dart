import 'package:dhbwstudentapp/common/logging/crash_reporting.dart';
import 'package:dhbwstudentapp/common/networking/NetworkRequestFailed.dart';
import 'package:dhbwstudentapp/dualis/model/module.dart';
import 'package:dhbwstudentapp/dualis/model/semester.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';

class ErrorReportDualisDecorator extends DualisService {
  final DualisService _dualisService;

  ErrorReportDualisDecorator(this._dualisService);

  @override
  Future<bool> login(String username, String password) async {
    try {
      return await _dualisService.login(username, password);
    } on NetworkRequestFailed catch (_) {
      rethrow;
    } catch (ex, trace) {
      await reportException(ex, trace);
    }
  }

  @override
  Future<List<Module>> queryAllModules() {
    // TODO: implement queryAllModules
    throw UnimplementedError();
  }

  @override
  Future<Semester> querySemester(String user) {
    // TODO: implement querySemester
    throw UnimplementedError();
  }

  @override
  Future<List<String>> querySemesterNames() {
    // TODO: implement querySemesterNames
    throw UnimplementedError();
  }

  @override
  Future<StudyGrades> queryStudyGrades() {
    // TODO: implement queryStudyGrades
    throw UnimplementedError();
  }
}
