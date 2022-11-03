import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class StudyGradesFromStudentResultsPageExtract {
  const StudyGradesFromStudentResultsPageExtract();

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

    final credits = _Credits(
      double.tryParse(neededCredits),
      double.tryParse(gainedCredits),
    );

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

    final _Gpa gpa = _Gpa(
      double.tryParse(totalGpa.replaceAll(",", ".")),
      double.tryParse(mainModulesGpa.replaceAll(",", ".")),
    );

    return gpa;
  }
}

class _Credits {
  final double? totalCredits;
  final double? gainedCredits;

  const _Credits(
    this.totalCredits,
    this.gainedCredits,
  );
}

class _Gpa {
  final double? totalGpa;
  final double? mainModulesGpa;

  const _Gpa(
    this.totalGpa,
    this.mainModulesGpa,
  );
}
