import 'dart:convert';

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

class DualisService {
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

  Future<List<Semester>> loadSemesters(
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

    var semesters = <Semester>[];

    for (var option in semesterSelector.getElementsByTagName("option")) {
      var id = option.attributes["value"];
      var name = option.innerHtml;

      semesters.add(Semester(name, url + id, []));
    }

    return semesters;
  }
}

class DualisMainPage {
  final String courseResultUrl;
  final String studentResultsUrl;

  DualisMainPage(this.courseResultUrl, this.studentResultsUrl);
}

class Semester {
  final String semesterName;
  final String semesterCourseResultsUrl;
  final List<Course> courses;

  Semester(this.semesterName, this.semesterCourseResultsUrl, this.courses);
}

class Course {
  final String id;
  final String name;
  final String finalGrade;
  final String credits;
  final String status;

  Course(this.id, this.name, this.finalGrade, this.credits, this.status);
}
