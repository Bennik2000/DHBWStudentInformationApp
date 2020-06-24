enum ExamState {
  Passed,
  Failed,
  Pending,
}

class Exam {
  final String id;
  final String name;
  final double grade;
  final ExamState state;

  Exam(
    this.id,
    this.name,
    this.grade,
    this.state,
  );
}
