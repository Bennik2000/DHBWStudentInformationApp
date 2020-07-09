import 'dart:io';

import 'package:dhbwstudentapp/dualis/model/exam.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/all_modules_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var studentResultsPage = await new File(Directory.current.absolute.path +
          '/test/dualis/service/parsing/html_resources/student_results.html')
      .readAsString();

  test('AllModulesExtract extract all modules', () async {
    var extract = AllModulesExtract();

    var modules = extract.extractAllModules(studentResultsPage);

    expect(modules.length, 6);

    expect(modules[1].id, "T3INF1002");
    expect(modules[1].name, "Theoretische Informatik I");
    expect(modules[1].credits, "5,0");
    expect(modules[1].finalGrade, "4,0");
    expect(modules[1].state, ExamState.Passed);

    expect(modules[0].state, ExamState.Pending);
  });

  test('AllModulesExtract invalid html throws exception', () async {
    var extract = AllModulesExtract();

    try {
      extract.extractAllModules("Lorem ipsum");
    } on ParseException {
      return;
    }

    fail("Exception not thrown!");
  });
}
