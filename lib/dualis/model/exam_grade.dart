enum ExamGradeState {
  NotGraded,
  Graded,
  Passed,
  Failed,
}

class ExamGrade {
  ExamGradeState state;
  String? gradeValue;

  ExamGrade.failed()
      : state = ExamGradeState.Failed,
        gradeValue = "";

  ExamGrade.notGraded()
      : state = ExamGradeState.NotGraded,
        gradeValue = "";

  ExamGrade.passed()
      : state = ExamGradeState.Passed,
        gradeValue = "";

  ExamGrade.graded(this.gradeValue) : state = ExamGradeState.Graded;

  factory ExamGrade.fromString(String? grade) {
    if (grade == "noch nicht gesetzt" || grade == "") {
      return ExamGrade.notGraded();
    }

    if (grade == "b") {
      return ExamGrade.passed();
    }

    // TODO: Determine the value when a exam is in the "failed" state
    //if (grade == "") {
    //  return ExamGrade.failed();
    //}

    return ExamGrade.graded(grade);
  }
}
