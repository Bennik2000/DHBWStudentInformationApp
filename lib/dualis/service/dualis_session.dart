import 'dart:convert';

import 'package:http/http.dart' as http;

class DualisSession extends Session {
  String mainPageUrl;
}

class Session {
  Map<String, String> headers = {};

  Future<String> get(String url) async {
    var response = await rawGet(url);
    String body = utf8.decode(response.bodyBytes);

    return body;
  }

  Future<http.Response> rawGet(String url) async {
    http.Response response = await http.get(url, headers: headers);
    _updateCookie(response);
    return response;
  }

  Future<http.Response> post(String url, dynamic data) async {
    http.Response response = await http.post(url, body: data, headers: headers);
    _updateCookie(response);
    return response;
  }

  void _updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}
