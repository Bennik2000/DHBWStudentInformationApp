import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class StudyGradesFromStudentResultsPageExtract {
  StudyGrades extractStudyGradesFromStudentsResultsPage(String body) {
    var document = parse(body);

    var tables = document.getElementsByTagName("tbody");

    var credits = _extractCredits(tables[0]);
    var gpa = _extractGpa(tables[1]);

    return StudyGrades(
      gpa.totalGpa,
      gpa.mainModulesGpa,
      credits.totalCredits,
      credits.gainedCredits,
    );
  }

  _Credits _extractCredits(Element table) {
    var rows = table.getElementsByTagName("tr");

    var neededCreditsRow = rows[rows.length - 1];
    var neededCredits = neededCreditsRow.children[0].innerHtml;

    // Only take the number after the colon
    neededCredits = trimAndEscapeString(neededCredits.split(":")[1]);

    var gainedCreditsRow = rows[rows.length - 2];
    var gainedCredits = trimAndEscapeString(
      gainedCreditsRow.children[2].innerHtml,
    );

    neededCredits = neededCredits.replaceAll(",", ".");
    gainedCredits = gainedCredits.replaceAll(",", ".");

    var credits = _Credits();
    credits.gainedCredits = double.tryParse(gainedCredits);
    credits.totalCredits = double.tryParse(neededCredits);

    return credits;
  }

  _Gpa _extractGpa(Element table) {
    var rows = table.getElementsByTagName("tr");

    var totalGpaRowCells = rows[0].getElementsByTagName("th");
    var totalGpa = trimAndEscapeString(
      totalGpaRowCells[1].innerHtml,
    );

    var mainCoursesGpaRowCells = rows[1].getElementsByTagName("th");
    var mainModulesGpa = trimAndEscapeString(
      mainCoursesGpaRowCells[1].innerHtml,
    );

    _Gpa gpa = _Gpa();
    gpa.totalGpa = double.tryParse(totalGpa.replaceAll(",", "."));
    gpa.mainModulesGpa = double.tryParse(mainModulesGpa.replaceAll(",", "."));

    return gpa;
  }
}

class _Credits {
  double totalCredits;
  double gainedCredits;
}

class _Gpa {
  double totalGpa;
  double mainModulesGpa;
}
