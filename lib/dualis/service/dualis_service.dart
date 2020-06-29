import 'dart:convert';

import 'package:dhbwstudentapp/dualis/model/exam.dart';
import 'package:dhbwstudentapp/dualis/model/module.dart';
import 'package:dhbwstudentapp/dualis/model/semester.dart';
import 'package:dhbwstudentapp/dualis/model/study_grades.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class Session {
  Map<String, String> headers = {};

  Future<http.Response> get(String url) async {
    http.Response response = await http.get(url, headers: headers);
    updateCookie(response);
    return response;
  }

  Future<http.Response> post(String url, dynamic data) async {
    http.Response response = await http.post(url, body: data, headers: headers);
    updateCookie(response);
    return response;
  }

  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}

class DualisScraper {
  Future<bool> makeRequest() async {
    var user = "";
    var password = "";

    var url = "https://dualis.dhbw.de/scripts/mgrqispi.dll";

    var session = Session();

    var data = {
      "usrname": user,
      "pass": password,
      "APPNAME": "CampusNet",
      "PRGNAME": "LOGINCHECK",
      "ARGUMENTS": "clino,usrname,pass,menuno,menu_type,browser,platform",
      "clino": "000000000000001",
      "menuno": "000324",
      "menu_type": "classic",
    };

    var loginResponse = await session.post(url, data);
    if (loginResponse.statusCode != 200) return false; // Login failed

    var refreshHeader = loginResponse.headers['refresh'];
    var refreshUrl = getUrlFromHeader(refreshHeader);

    var redirectResponse = await session.get(refreshUrl);

    var redirectUrl = readRedirectUrl(redirectResponse.body);

    var mainPageResponse = await session.get(redirectUrl);

    var mainPage = parseMainPage(mainPageResponse.body);

    var semesters = await loadSemesters(mainPage, session);

    print("Loaded semesters: ");

    for (var semester in semesters) {
      print("${semester.semesterName}:");

      for (var course in semester.courses) {
        print("  ${course.id} ${course.name} ${course.finalGrade}");
      }
    }

    return true;
  }

  String getUrlFromHeader(String refreshHeader) {
    var refreshHeaderUrlIndex = refreshHeader.indexOf("URL=") + "URL=".length;

    return "https://dualis.dhbw.de" +
        refreshHeader.substring(refreshHeaderUrlIndex);
  }

  String readRedirectUrl(String body) {
    var document = parse(body);

    var metaTags = document.getElementsByTagName("meta");

    var redirectContent;

    for (var metaTag in metaTags) {
      if (!metaTag.attributes.containsKey("http-equiv")) continue;

      var httpEquiv = metaTag.attributes["http-equiv"];

      if (httpEquiv != "refresh") continue;
      if (!metaTag.attributes.containsKey("content")) continue;

      redirectContent = metaTag.attributes["content"];
      break;
    }

    return getUrlFromHeader(redirectContent);
  }

  DualisMainPage parseMainPage(String body) {
    var document = parse(body);

    var courseResultsElement = document.getElementsByClassName("link000307");
    var studentResultsElement = document.getElementsByClassName("link000310");

    var courseResultsUrl =
        "https://dualis.dhbw.de" + courseResultsElement[0].attributes['href'];

    var studentResultsUrl =
        "https://dualis.dhbw.de" + studentResultsElement[0].attributes['href'];

    return DualisMainPage(
      courseResultsUrl,
      studentResultsUrl,
    );
  }

  Future<List<DualisSemester>> loadSemesters(
    DualisMainPage mainPage,
    Session session,
  ) async {
    var courseResult = await session.get(mainPage.courseResultUrl);

    var page = parse(courseResult.body);

    var semesterSelector = page.getElementById("semester");

    var onChange = semesterSelector.attributes["onchange"];

    var regExp = RegExp("'([A-z0-9]*)'");

    var matches = regExp.allMatches(onChange).toList();

    if (matches.length != 4) return null;

    var applicationName = matches[0].group(1);
    var programName = matches[1].group(1);
    var sessionNo = matches[2].group(1);
    var menuId = matches[3].group(1);

    var url =
        "https://dualis.dhbw.de/scripts/mgrqispi.dll?APPNAME=$applicationName&PRGNAME=$programName&ARGUMENTS=-N$sessionNo,-N$menuId,-N";

    var semesters = <DualisSemester>[];

    for (var option in semesterSelector.getElementsByTagName("option")) {
      var id = option.attributes["value"];
      var name = option.innerHtml;

      semesters.add(DualisSemester(name, url + id, []));
    }

    for (var semester in semesters) {
      await loadSemester(semester, session);
    }

    return semesters;
  }

  Future<void> loadSemester(DualisSemester semester, Session session) async {
    var coursePage = await session.get(semester.semesterCourseResultsUrl);

    var document = parse(coursePage.body);

    var tableBodies = document.getElementsByTagName("tbody");

    for (var row in tableBodies[0].getElementsByTagName("tr")) {
      if (row.children[0].localName != "td") continue;

      var id = row.children[0].innerHtml.trim();
      var name = row.children[1].innerHtml.trim();
      var grade = row.children[2].innerHtml.trim();
      var credits = row.children[3].innerHtml.trim();
      var status = row.children[4].innerHtml.trim();
      var detailsButton = row.children[0];

      semester.courses.add(DualisCourse(id, name, grade, credits, status, ""));
    }
  }
}

class DualisMainPage {
  final String courseResultUrl;
  final String studentResultsUrl;

  DualisMainPage(
    this.courseResultUrl,
    this.studentResultsUrl,
  );
}

class DualisSemester {
  final String semesterName;
  final String semesterCourseResultsUrl;
  final List<DualisCourse> courses;

  DualisSemester(
    this.semesterName,
    this.semesterCourseResultsUrl,
    this.courses,
  );
}

class DualisCourse {
  final String id;
  final String name;
  final String finalGrade;
  final String credits;
  final String status;
  final String detailsUrl;

  DualisCourse(
    this.id,
    this.name,
    this.finalGrade,
    this.credits,
    this.status,
    this.detailsUrl,
  );
}

class DualisService {
  Future<bool> login(String username, String password) async {
    await Future.delayed(Duration(seconds: 2));

    return username == "user" && password == "123456";
  }

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
