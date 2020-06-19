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

    var result = await session.get(mainPage.courseResultUrl);

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
}

class DualisMainPage {
  final String courseResultUrl;
  final String studentResultsUrl;

  DualisMainPage(this.courseResultUrl, this.studentResultsUrl);
}
