import 'package:dhbwstudentapp/dualis/model/exam_grade.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:html/parser.dart';

class ExamsFromModuleDetailsExtract {
  List<DualisExam> extractExamsFromModuleDetails(String? body) {
    try {
      return _extractExamsFromModuleDetails(body);
    } on ParseException catch (e, trace) {
      if (e.runtimeType is ParseException) rethrow;
      throw ParseException.withInner(e, trace);
    }
  }

  List<DualisExam> _extractExamsFromModuleDetails(String? body) {
    final document = parse(body);

    final tableExams = getElementByTagName(document, "tbody");
    final tableExamsRows = tableExams.getElementsByTagName("tr");

    String? currentTry;
    String? currentModule;

    final exams = <DualisExam>[];

    for (final row in tableExamsRows) {
      // Save the try for all following exams
      final level01s = row.getElementsByClassName("level01");
      if (level01s.isNotEmpty) {
        currentTry = level01s[0].innerHtml;
        continue;
      }

      // Save the module for all following exams
      final level02s = row.getElementsByClassName("level02");
      if (level02s.isNotEmpty) {
        currentModule = level02s[0].innerHtml;
        continue;
      }

      // All exam rows contain cells with the tbdata class.
      // If there are none continue with the next row
      final tbdata = row.getElementsByClassName("tbdata");
      if (tbdata.length < 4) continue;

      final semester = tbdata[0].innerHtml;
      final name = tbdata[1].innerHtml;
      final grade = trimAndEscapeString(tbdata[3].innerHtml);

      exams.add(DualisExam(
        trimAndEscapeString(name),
        trimAndEscapeString(currentModule),
        ExamGrade.fromString(grade),
        trimAndEscapeString(currentTry),
        trimAndEscapeString(semester),
      ),);
    }

    return exams;
  }
}
