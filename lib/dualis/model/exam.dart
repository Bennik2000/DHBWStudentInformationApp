import 'package:dhbwstudentapp/dualis/model/exam_grade.dart';

enum ExamState {
  Passed,
  Failed,
  Pending,
}

class Exam {
  final String name;
  final ExamGrade grade;
  final String semester;
  final ExamState state;

  Exam(
    this.name,
    this.grade,
    this.state,
    this.semester,
  );
}
