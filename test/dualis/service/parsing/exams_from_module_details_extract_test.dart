import 'dart:io';

import 'package:dhbwstudentapp/dualis/service/parsing/exams_from_module_details_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var moduleDetailsPage = await new File(Directory.current.absolute.path +
          '/test/dualis/service/parsing/html_resources/module_details.html')
      .readAsString();

  test('ExamsFromModuleDetailsExtract', () async {
    var extract = ExamsFromModuleDetailsExtract();

    var exams = extract.extractExamsFromModuleDetails(moduleDetailsPage);

    expect(exams.length, 2);

    expect(exams[0].name, "Klausurarbeit (50%)");
    expect(exams[0].semester, "WiSe xx/yy");
    expect(exams[0].grade, "4,0");
    expect(exams[0].moduleName, "T3INF1001.1 Lineare Algebra (STG-TINF19IN)");
    expect(exams[0].tryNr, "Versuch  1");

    expect(exams[1].grade, "");
  });

  test('ExamsFromModuleDetailsExtract invalid html throws exception', () async {
    var extract = ExamsFromModuleDetailsExtract();

    try {
      extract.extractExamsFromModuleDetails("Lorem ipsum");
    } on ParseException {
      return;
    }

    fail("Exception not thrown!");
  });
}
