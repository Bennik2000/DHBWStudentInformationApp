import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:dhbwstudentapp/schedule/service/mannheim/mannheim_course_scraper.dart';
import 'package:html/parser.dart';

class MannheimCourseResponseParser {
  List<Course> parseCoursePage(String body) {
    final document = parse(body);

    final selectElement = getElementById(document, "class_select");
    final options = selectElement.getElementsByTagName("option");

    final courses = <Course>[];

    for (final e in options) {
      final label = e.attributes["label"] ?? "";
      final value = e.attributes["value"] ?? "";
      final title = e.parent!.attributes["label"] ?? "";

      if (label == "" || value == "") continue;
      if (label.trim() == "Kurs auswählen") continue;

      courses.add(
        Course(
          label,
          "http://vorlesungsplan.dhbw-mannheim.de/ical.php?uid=$value",
          title,
          value,
        ),
      );
    }

    courses.sort((c1, c2) => c1.name.compareTo(c2.name));

    return courses;
  }
}
