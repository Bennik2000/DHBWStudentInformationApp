enum ExamGradeState {
  NotGraded,
  Graded,
  Passed,
  Failed,
}

// TODO: [leptopoda] implement into the enum
class ExamGrade {
  final ExamGradeState state;
  final String? gradeValue;

  const ExamGrade.failed()
      : state = ExamGradeState.Failed,
        gradeValue = "";

  const ExamGrade.notGraded()
      : state = ExamGradeState.NotGraded,
        gradeValue = "";

  const ExamGrade.passed()
      : state = ExamGradeState.Passed,
        gradeValue = "";

  ExamGrade.graded(this.gradeValue) : state = ExamGradeState.Graded;

  factory ExamGrade.fromString(String? grade) {
    if (grade == "noch nicht gesetzt" || grade == "") {
      return const ExamGrade.notGraded();
    }

    if (grade == "b") {
      return const ExamGrade.passed();
    }

    // TODO: Determine the value when a exam is in the "failed" state
    //if (grade == "") {
    //  return ExamGrade.failed();
    //}

    return ExamGrade.graded(grade);
  }
}
