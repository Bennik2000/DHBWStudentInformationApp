import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:html/parser.dart';

class ExamsFromModuleDetailsExtract {
  List<DualisExam> extractExamsFromModuleDetails(String body) {
    try {
      return _extractExamsFromModuleDetails(body);
    } on ParseException catch (e) {
      if (e.runtimeType is ParseException) rethrow;
      throw ParseException.withInner(e);
    }
  }

  List<DualisExam> _extractExamsFromModuleDetails(String body) {
    var document = parse(body);

    var tableExams = getElementByTagName(document, "tbody");
    var tableExamsRows = tableExams.getElementsByTagName("tr");

    String currentTry;
    String currentModule;

    var exams = <DualisExam>[];

    for (var row in tableExamsRows) {
      // Save the try for all following exams
      var level01s = row.getElementsByClassName("level01");
      if (level01s.length > 0) {
        currentTry = level01s[0].innerHtml;
        continue;
      }

      // Save the module for all following exams
      var level02s = row.getElementsByClassName("level02");
      if (level02s.length > 0) {
        currentModule = level02s[0].innerHtml;
        continue;
      }

      // All exam rows contain cells with the tbdata class.
      // If there are none continue with the next row
      var tbdata = row.getElementsByClassName("tbdata");
      if (tbdata.length < 4) continue;

      var semester = tbdata[0].innerHtml;
      var name = tbdata[1].innerHtml;
      var grade = trimAndEscapeString(tbdata[3].innerHtml);

      if (grade == "noch nicht gesetzt") {
        grade = "";
      }

      exams.add(DualisExam(
        trimAndEscapeString(name),
        trimAndEscapeString(currentModule),
        grade,
        trimAndEscapeString(currentTry),
        trimAndEscapeString(semester),
      ));
    }

    return exams;
  }
}
