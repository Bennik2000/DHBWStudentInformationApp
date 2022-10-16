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
      String? body, String endpointUrl) {
    var page = parse(body);

    var semesterSelector = page.getElementById("semester");

    if (semesterSelector == null)
      throw ElementNotFoundParseException("semester selector container");

    var url = _extractSemesterDetailUrlPart(semesterSelector, endpointUrl);

    var semesters = <DualisSemester>[];

    for (var option in semesterSelector.getElementsByTagName("option")) {
      var id = option.attributes["value"];
      var name = option.innerHtml;

      String? detailsUrl;

      if (url != null) {
        detailsUrl = url + id!;
      }

      semesters.add(DualisSemester(
        name,
        detailsUrl,
        [],
      ));
    }

    return semesters;
  }

  String? _extractSemesterDetailUrlPart(
    Element semesterSelector,
    String endpointUrl,
  ) {
    var dropDownSemesterSelector = semesterSelector.attributes["onchange"]!;

    var regExp = RegExp("'([A-z0-9]*)'");

    var matches = regExp.allMatches(dropDownSemesterSelector).toList();

    if (matches.length != 4) return null;

    var applicationName = matches[0].group(1);
    var programName = matches[1].group(1);
    var sessionNo = matches[2].group(1);
    var menuId = matches[3].group(1);

    var url = endpointUrl + "/scripts/mgrqispi.dll";
    url += "?APPNAME=$applicationName";
    url += "&PRGNAME=$programName";
    url += "&ARGUMENTS=-N$sessionNo,-N$menuId,-N";

    return url;
  }
}
