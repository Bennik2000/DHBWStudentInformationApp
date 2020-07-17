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
      rethrow;
    }
  }

  @override
  Future<List<Module>> queryAllModules() async {
    try {
      return await _dualisService.queryAllModules();
    } on NetworkRequestFailed catch (_) {
      rethrow;
    } catch (ex, trace) {
      await reportException(ex, trace);
      rethrow;
    }
  }

  @override
  Future<Semester> querySemester(String name) async {
    try {
      return await _dualisService.querySemester(name);
    } on NetworkRequestFailed catch (_) {
      rethrow;
    } catch (ex, trace) {
      await reportException(ex, trace);
      rethrow;
    }
  }

  @override
  Future<List<String>> querySemesterNames() async {
    try {
      return await _dualisService.querySemesterNames();
    } on NetworkRequestFailed catch (_) {
      rethrow;
    } catch (ex, trace) {
      await reportException(ex, trace);
      rethrow;
    }
  }

  @override
  Future<StudyGrades> queryStudyGrades() async {
    try {
      return await _dualisService.queryStudyGrades();
    } on NetworkRequestFailed catch (_) {
      rethrow;
    } catch (ex, trace) {
      await reportException(ex, trace);
      rethrow;
    }
  }
}
