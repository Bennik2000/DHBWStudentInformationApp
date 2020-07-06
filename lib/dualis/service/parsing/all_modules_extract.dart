import 'package:dhbwstudentapp/dualis/model/exam.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class AllModulesExtract {
  List<DualisModule> extractAllModules(String body) {
    try {
      return _extractAllModules(body);
    } catch (e) {
      if (e.runtimeType is ParseException) rethrow;
      throw new ParseException.withInner(e);
    }
  }

  List<DualisModule> _extractAllModules(String body) {
    var document = parse(body);

    var modulesTable = getElementByTagName(document, "tbody");
    var rows = modulesTable.getElementsByTagName("tr");

    var modules = <DualisModule>[];

    for (var row in rows) {
      // Rows with the subhead class do not contain any modules
      if (row.classes.contains("subhead")) continue;

      // When there are not 6 cells the row is not a module
      var cells = row.getElementsByClassName("tbdata");
      if (cells.length != 6) continue;

      modules.add(_extractModuleFromCells(cells));
    }

    return modules;
  }

  DualisModule _extractModuleFromCells(List<Element> cells) {
    var name = cells[1].innerHtml.trim();
    var nameHyperlink = cells[1].getElementsByTagName("a");

    if (nameHyperlink.length != 0) {
      name = nameHyperlink[0].innerHtml;
    }

    var id = cells[0].innerHtml;
    var credits = cells[3].innerHtml;
    var grade = cells[4].innerHtml;
    var state = cells[5].children[0].attributes["alt"];

    var stateEnum;

    if (state == "Bestanden") {
      stateEnum = ExamState.Passed;
    }
    if (state == "Offen") {
      stateEnum = ExamState.Pending;
    }

    var module = DualisModule(
      trimAndEscapeString(id),
      trimAndEscapeString(name),
      trimAndEscapeString(grade),
      trimAndEscapeString(credits),
      stateEnum,
      null,
    );

    return module;
  }
}
