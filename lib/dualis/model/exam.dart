enum ExamState {
  Passed,
  Failed,
  Pending,
}

class Exam {
  final String name;
  final String grade;
  final ExamState state;

  Exam(
    this.name,
    this.grade,
    this.state,
  );
}
