import 'package:dhbwstudentapp/dualis/model/exam.dart';
import 'package:dhbwstudentapp/dualis/model/module.dart';
import 'package:dhbwstudentapp/dualis/model/semester.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_scraper.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_session.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:flutter/widgets.dart';

abstract class DualisService {
  Future<bool> login(String username, String password);

  Future<StudyGrades> queryStudyGrades();
}

class DualisServiceImpl extends DualisService {
  final DualisScraper _dualisScraper = DualisScraper();

  DualisSession _session;

  @override
  Future<bool> login(String username, String password) async {
    _session = await _dualisScraper.login(username, password);

    return _session != null;
  }

  @override
  Future<StudyGrades> queryStudyGrades() async {
    var mainPage = await _dualisScraper.requestMainPage(_session);
    var allSemesters = await _dualisScraper.loadAllSemesters(
      _session,
      mainPage,
    );

    var semesters = <Semester>[];
    var allModules = <Module>[];

    for (var dualisSemester in allSemesters) {
      var semesterModules = <Module>[];

      for (var dualisModule in dualisSemester.modules) {
        var module = Module(
          <Exam>[],
          dualisModule.id,
          dualisModule.name,
          dualisModule.credits,
          dualisModule.finalGrade,
        );

        allModules.add(module); // TODO: This is not the correct way. Parse from dualis

        semesterModules.add(module);
      }

      semesters.add(Semester(
        dualisSemester.semesterName,
        semesterModules,
      ));
    }

    var gpaTotal = 0.0;
    var gpaMainModules = 0.0;
    var creditsTotal = 0;
    var creditsGained = 0;

    return StudyGrades(
      semesters,
      allModules,
      gpaTotal,
      gpaMainModules,
      creditsTotal,
      creditsGained,
    );
  }
}

class DummyDualisService extends DualisService {
  @override
  Future<bool> login(String username, String password) async {
    await Future.delayed(Duration(seconds: 1));

    return username == "user" && password == "123456";
  }

  @override
  Future<StudyGrades> queryStudyGrades() async {
    return StudyGrades(
      <Semester>[
        Semester(
          "WiSe 2020",
          <Module>[
            Module(<Exam>[
              Exam(
                "T2022",
                "Klausur",
                1.4,
                ExamState.Passed,
              ),
            ], "T2022", "Mathematik I", "8", ""),
            Module(
              <Exam>[
                Exam(
                  "T2023",
                  "Klausur",
                  2.0,
                  ExamState.Passed,
                ),
              ],
              "T2023",
              "Theoretische Informatik I",
              "8",
              "2.0",
            ),
            Module(
              <Exam>[
                Exam(
                  "T2024",
                  "Klausur",
                  1.7,
                  ExamState.Pending,
                ),
              ],
              "T2024",
              "Technische Informatik I",
              "8",
              "2.0",
            ),
            Module(
              <Exam>[
                Exam(
                  "T2025",
                  "Klausur",
                  1.0,
                  ExamState.Failed,
                ),
              ],
              "T2025",
              "Elektrotechnik",
              "8",
              "2.0",
            ),
          ],
        ),
        Semester("SoSe 2020", <Module>[]),
        Semester("WiSe 2020", <Module>[]),
      ],
      <Module>[
        Module(
          <Exam>[
            Exam(
              "T2022",
              "Klausur",
              1.4,
              ExamState.Pending,
            ),
          ],
          "T2022",
          "Mathematik I",
          "8",
          "2.0",
        ),
        Module(
          <Exam>[
            Exam(
              "T2023",
              "Klausur",
              2.0,
              ExamState.Passed,
            ),
          ],
          "T2023",
          "Theoretische Informatik I",
          "8",
          "2.0",
        ),
        Module(
          <Exam>[
            Exam(
              "T2024",
              "Klausur",
              1.7,
              ExamState.Passed,
            ),
          ],
          "T2024",
          "Technische Informatik I",
          "8",
          "2.0",
        ),
        Module(
          <Exam>[
            Exam(
              "T2025",
              "Klausur",
              1.0,
              ExamState.Passed,
            ),
          ],
          "T2025",
          "Elektrotechnik",
          "8",
          "2.0",
        ),
      ],
      1.4,
      1.5,
      209,
      9,
    );
  }
}

class AuthenticationFailedException implements Exception {}
