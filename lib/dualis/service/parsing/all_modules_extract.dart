import 'package:dhbwstudentapp/dualis/model/exam.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class AllModulesExtract {
  const AllModulesExtract();

  List<DualisModule> extractAllModules(String? body) {
    try {
      return _extractAllModules(body);
    } catch (e, trace) {
      if (e.runtimeType is ParseException) rethrow;
      throw ParseException.withInner(e, trace);
    }
  }

  List<DualisModule> _extractAllModules(String? body) {
    final document = parse(body);

    final modulesTable = getElementByTagName(document, "tbody");
    final rows = modulesTable.getElementsByTagName("tr");

    final modules = <DualisModule>[];

    for (final row in rows) {
      // Rows with the subhead class do not contain any modules
      if (row.classes.contains("subhead")) continue;

      // When there are not 6 cells the row is not a module
      final cells = row.getElementsByClassName("tbdata");
      if (cells.length != 6) continue;

      modules.add(_extractModuleFromCells(cells));
    }

    return modules;
  }

  DualisModule _extractModuleFromCells(List<Element> cells) {
    var name = cells[1].innerHtml.trim();
    final nameHyperlink = cells[1].getElementsByTagName("a");

    if (nameHyperlink.isNotEmpty) {
      name = nameHyperlink[0].innerHtml;
    }

    final id = cells[0].innerHtml;
    final credits = cells[3].innerHtml;
    final grade = cells[4].innerHtml;
    final state = cells[5].children[0].attributes["alt"];

    ExamState? stateEnum;

    if (state == "Bestanden") {
      stateEnum = ExamState.Passed;
    }
    if (state == "Offen") {
      stateEnum = ExamState.Pending;
    }

    final module = DualisModule(
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
