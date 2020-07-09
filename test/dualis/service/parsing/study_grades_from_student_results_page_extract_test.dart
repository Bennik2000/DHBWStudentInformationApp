import 'dart:io';

import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/study_grades_from_student_results_page_extract.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var studentResultsPage = await new File(Directory.current.absolute.path +
          '/test/dualis/service/parsing/html_resources/student_results.html')
      .readAsString();

  test('StudyGradesFromStudentResultsPageExtract', () async {
    var extract = StudyGradesFromStudentResultsPageExtract();

    var studyGrades =
        extract.extractStudyGradesFromStudentsResultsPage(studentResultsPage);

    expect(studyGrades.creditsGained, 13);
    expect(studyGrades.creditsTotal, 210);

    expect(studyGrades.gpaTotal, 3.0);
    expect(studyGrades.gpaMainModules, 3.1);
  });

  test('StudyGradesFromStudentResultsPageExtract invalid html throws exception',
      () async {
    var extract = StudyGradesFromStudentResultsPageExtract();

    try {
      extract.extractStudyGradesFromStudentsResultsPage("Lorem ipsum");
    } on ParseException {
      return;
    }

    fail("Exception not thrown!");
  });
}
