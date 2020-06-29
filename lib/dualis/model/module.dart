import 'package:dhbwstudentapp/dualis/model/exam.dart';

class Module {
  final List<Exam> exams;
  final String id;
  final String name;
  final String credits;
  final String grade;

  Module(
    this.exams,
    this.id,
    this.name,
    this.credits,
    this.grade,
  );
}
