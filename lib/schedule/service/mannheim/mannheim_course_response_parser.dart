import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:dhbwstudentapp/schedule/service/mannheim/mannheim_course_scraper.dart';
import 'package:html/parser.dart';

class MannheimCourseResponseParser {
  List<Course> parseCoursePage(String body) {
    var document = parse(body);

    var selectElement = getElementById(document, "class_select");
    var options = selectElement.getElementsByTagName("option");

    var courses = <Course>[];

    for (var e in options) {
      var label = e.attributes["label"] ?? "";
      var value = e.attributes["value"] ?? "";
      var title = e.parent!.attributes["label"] ?? "";

      if (label == "" || value == "") continue;
      if (label.trim() == "Kurs auswählen") continue;

      courses.add(Course(
        label,
        "http://vorlesungsplan.dhbw-mannheim.de/ical.php?uid=$value",
        title,
        value,
      ));
    }

    courses.sort((c1, c2) => c1.name.compareTo(c2.name));

    return courses;
  }
}
