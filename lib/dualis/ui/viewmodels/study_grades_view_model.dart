import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/dualis/model/exam.dart';
import 'package:dhbwstudentapp/dualis/model/module.dart';
import 'package:dhbwstudentapp/dualis/model/semester.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';

class StudyGradesViewModel extends BaseViewModel {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _loginFailed = false;
  bool get loginFailed => _loginFailed;

  DualisService dualisService;

  StudyGrades _studyGrades;
  StudyGrades get studyGrades => _studyGrades;

  StudyGradesViewModel() {
    dualisService = DualisServiceImpl();
  }

  Future<bool> login(String username, String password) async {
    bool success = await dualisService.login(username, password);

    if (success) {
      _loginFailed = false;
      _isLoggedIn = true;
    } else {
      _loginFailed = true;
      _isLoggedIn = false;
    }

    _studyGrades = await dualisService.queryStudyGrades();

    for (var s in _studyGrades.semesters) {
      print("Semester ${s.name}");

      for (var m in s.modules) {
        print("Module ${m.name} grade: ${m.grade}");
      }
    }

    notifyListeners("loginFailed");
    notifyListeners("isLoggedIn");

    return success;
  }
}
