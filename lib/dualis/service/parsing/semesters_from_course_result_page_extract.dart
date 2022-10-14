import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class SemestersFromCourseResultPageExtract {
  List<DualisSemester> extractSemestersFromCourseResults(
    String? body,
    String endpointUrl,
  ) {
    try {
      return _extractSemestersFromCourseResults(body, endpointUrl);
    } catch (e, trace) {
      if (e.runtimeType is ParseException) rethrow;
      throw ParseException.withInner(e, trace);
    }
  }

  List<DualisSemester> _extractSemestersFromCourseResults(
      String? body, String endpointUrl,) {
    final page = parse(body);

    final semesterSelector = page.getElementById("semester");

    if (semesterSelector == null) {
      throw ElementNotFoundParseException("semester selector container");
    }

    final url = _extractSemesterDetailUrlPart(semesterSelector, endpointUrl);

    final semesters = <DualisSemester>[];

    for (final option in semesterSelector.getElementsByTagName("option")) {
      final id = option.attributes["value"];
      final name = option.innerHtml;

      String? detailsUrl;

      if (url != null) {
        detailsUrl = url + id!;
      }

      semesters.add(DualisSemester(
        name,
        detailsUrl,
        [],
      ),);
    }

    return semesters;
  }

  String? _extractSemesterDetailUrlPart(
    Element semesterSelector,
    String endpointUrl,
  ) {
    final dropDownSemesterSelector = semesterSelector.attributes["onchange"]!;

    final regExp = RegExp("'([A-z0-9]*)'");

    final matches = regExp.allMatches(dropDownSemesterSelector).toList();

    if (matches.length != 4) return null;

    final applicationName = matches[0].group(1);
    final programName = matches[1].group(1);
    final sessionNo = matches[2].group(1);
    final menuId = matches[3].group(1);

    var url = endpointUrl + "/scripts/mgrqispi.dll";
    url += "?APPNAME=$applicationName";
    url += "&PRGNAME=$programName";
    url += "&ARGUMENTS=-N$sessionNo,-N$menuId,-N";

    return url;
  }
}
