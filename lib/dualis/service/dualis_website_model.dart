class DualisMainPage {
  final String courseResultUrl;
  final String studentResultsUrl;

  DualisMainPage(
    this.courseResultUrl,
    this.studentResultsUrl,
  );
}

class DualisSemester {
  final String semesterName;
  final String semesterCourseResultsUrl;
  final List<DualisModule> modules;

  DualisSemester(
    this.semesterName,
    this.semesterCourseResultsUrl,
    this.modules,
  );
}

class DualisModule {
  final String id;
  final String name;
  final String finalGrade;
  final String credits;
  final String status;
  final String detailsUrl;
  final List<DualisExam> exams;

  DualisModule(
    this.id,
    this.name,
    this.finalGrade,
    this.credits,
    this.status,
    this.detailsUrl,
    this.exams,
  );
}

class DualisExam {
  final String tryNr;
  final String moduleName;
  final String name;
  final String grade;

  DualisExam(
    this.name,
    this.moduleName,
    this.grade,
    this.tryNr,
  );
}
