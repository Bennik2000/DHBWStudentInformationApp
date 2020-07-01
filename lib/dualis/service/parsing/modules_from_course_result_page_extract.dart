import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class ModulesFromCourseResultPageExtract {
  final RegExp _extractUrlRegex = RegExp('dl_popUp\\("(.+?)"');

  List<DualisModule> extractModulesFromCourseResultPage(
    String body,
    String endpointUrl,
  ) {
    var document = parse(body);

    var tableBodies = document.getElementsByTagName("tbody");

    var modulesOfSemester = <DualisModule>[];

    for (var row in tableBodies[0].getElementsByTagName("tr")) {
      // Only rows with tds as child are modules
      if (row.children[0].localName != "td") continue;

      DualisModule module = _extractModuleFromRow(row, endpointUrl);
      modulesOfSemester.add(module);
    }

    return modulesOfSemester;
  }

  DualisModule _extractModuleFromRow(
    Element row,
    String endpointUrl,
  ) {
    var id = row.children[0].innerHtml;
    var name = row.children[1].innerHtml;
    var grade = row.children[2].innerHtml;
    var credits = row.children[3].innerHtml;
    var status = row.children[4].innerHtml;
    var detailsButton = row.children[5];
    var url = _extractDetailsUrlFromButton(detailsButton, endpointUrl);

    var module = DualisModule(
      trimAndEscapeString(id),
      trimAndEscapeString(name),
      trimAndEscapeString(grade),
      trimAndEscapeString(credits),
      trimAndEscapeString(status),
      url,
    );
    return module;
  }

  String _extractDetailsUrlFromButton(
    Element detailsButton,
    String endpointUrl,
  ) {
    var firstMatch = _extractUrlRegex.firstMatch(detailsButton.innerHtml);
    var url = firstMatch?.group(1);

    if (url != null) {
      url = endpointUrl + url;
    }

    return url;
  }
}
