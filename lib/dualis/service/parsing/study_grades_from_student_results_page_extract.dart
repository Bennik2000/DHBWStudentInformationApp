import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class StudyGradesFromStudentResultsPageExtract {
  StudyGrades extractStudyGradesFromStudentsResultsPage(String? body) {
    try {
      return _extractStudyGradesFromStudentsResultsPage(body);
    } catch (e, trace) {
      if (e.runtimeType is ParseException) rethrow;
      throw ParseException.withInner(e, trace);
    }
  }

  StudyGrades _extractStudyGradesFromStudentsResultsPage(String? body) {
    final document = parse(body);

    final creditsTable = getElementByTagName(document, "tbody");
    final gpaTable = getElementByTagName(document, "tbody", 1);

    final credits = _extractCredits(creditsTable);
    final gpa = _extractGpa(gpaTable);

    return StudyGrades(
      gpa.totalGpa,
      gpa.mainModulesGpa,
      credits.totalCredits,
      credits.gainedCredits,
    );
  }

  _Credits _extractCredits(Element table) {
    final rows = table.getElementsByTagName("tr");

    if (rows.length < 2) {
      throw ElementNotFoundParseException("credits container");
    }

    final neededCreditsRow = rows[rows.length - 1];
    var neededCredits = neededCreditsRow.children[0].innerHtml;

    // Only take the number after the colon
    neededCredits = trimAndEscapeString(neededCredits.split(":")[1])!;

    final gainedCreditsRow = rows[rows.length - 2];
    var gainedCredits = trimAndEscapeString(
      gainedCreditsRow.children[2].innerHtml,
    )!;

    neededCredits = neededCredits.replaceAll(",", ".");
    gainedCredits = gainedCredits.replaceAll(",", ".");

    final credits = _Credits();
    credits.gainedCredits = double.tryParse(gainedCredits);
    credits.totalCredits = double.tryParse(neededCredits);

    return credits;
  }

  _Gpa _extractGpa(Element table) {
    final rows = table.getElementsByTagName("tr");

    if (rows.length < 2) throw ElementNotFoundParseException("gpa container");

    final totalGpaRowCells = rows[0].getElementsByTagName("th");
    final totalGpa = trimAndEscapeString(
      totalGpaRowCells[1].innerHtml,
    )!;

    final mainCoursesGpaRowCells = rows[1].getElementsByTagName("th");
    final mainModulesGpa = trimAndEscapeString(
      mainCoursesGpaRowCells[1].innerHtml,
    )!;

    final _Gpa gpa = _Gpa();
    gpa.totalGpa = double.tryParse(totalGpa.replaceAll(",", "."));
    gpa.mainModulesGpa = double.tryParse(mainModulesGpa.replaceAll(",", "."));

    return gpa;
  }
}

class _Credits {
  double? totalCredits;
  double? gainedCredits;
}

class _Gpa {
  double? totalGpa;
  double? mainModulesGpa;
}
