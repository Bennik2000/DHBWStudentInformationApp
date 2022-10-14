import 'package:dhbwstudentapp/dualis/model/exam.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class ModulesFromCourseResultPageExtract {
  final RegExp _extractUrlRegex = RegExp('dl_popUp\\("(.+?)"');

  List<DualisModule?> extractModulesFromCourseResultPage(
    String? body,
    String endpointUrl,
  ) {
    try {
      return _extractModulesFromCourseResultPage(body, endpointUrl);
    } catch (e, trace) {
      if (e.runtimeType is ParseException) rethrow;
      throw ParseException.withInner(e, trace);
    }
  }

  List<DualisModule?> _extractModulesFromCourseResultPage(
      String? body, String endpointUrl,) {
    final document = parse(body);

    final tableBodies = getElementByTagName(document, "tbody");
    final rows = tableBodies.getElementsByTagName("tr");

    final modulesOfSemester = <DualisModule?>[];

    for (final row in rows) {
      // Only rows with tds as child are modules
      if (row.children[0].localName != "td") continue;

      final DualisModule? module = _extractModuleFromRow(row, endpointUrl);
      modulesOfSemester.add(module);
    }

    return modulesOfSemester;
  }

  DualisModule? _extractModuleFromRow(
    Element row,
    String endpointUrl,
  ) {
    if (row.children.length < 6) return null;

    final id = row.children[0].innerHtml;
    final name = row.children[1].innerHtml;
    var grade = row.children[2].innerHtml;
    final credits = row.children[3].innerHtml;
    String? status = row.children[4].innerHtml;
    final detailsButton = row.children[5];
    final url = _extractDetailsUrlFromButton(detailsButton, endpointUrl);

    status = trimAndEscapeString(status);

    ExamState? statusEnum;

    if (status == "bestanden") {
      statusEnum = ExamState.Passed;
    }

    if (grade == "noch nicht gesetzt") {
      grade = "";
    }

    final module = DualisModule(
      trimAndEscapeString(id),
      trimAndEscapeString(name),
      trimAndEscapeString(grade),
      trimAndEscapeString(credits),
      statusEnum,
      url,
    );
    return module;
  }

  String? _extractDetailsUrlFromButton(
    Element detailsButton,
    String endpointUrl,
  ) {
    final firstMatch = _extractUrlRegex.firstMatch(detailsButton.innerHtml);
    var url = firstMatch?.group(1);

    if (url != null) {
      url = endpointUrl + url;
    }

    return url;
  }
}
