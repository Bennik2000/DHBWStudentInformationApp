import 'dart:convert';

import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:http_client_helper/http_client_helper.dart' as http;
import 'package:http/http.dart';

class DualisSession extends Session {
  String mainPageUrl;
}

class Session {
  Map<String, String> cookies = {};

  Future<String> get(String url, [CancellationToken cancellationToken]) async {
    var response = await rawGet(url, cancellationToken);

    if (response == null) {
      return null;
    }

    return utf8.decode(response.bodyBytes);
  }

  Future<Response> rawGet(
    String url, [
    CancellationToken cancellationToken,
  ]) async {
    if (cancellationToken == null) cancellationToken = CancellationToken();

    var requestCancellationToken = http.CancellationToken();

    try {
      cancellationToken.setCancellationCallback(() {
        requestCancellationToken.cancel();
      });

      var requestUri = Uri.parse(url);

      var response = await http.HttpClientHelper.get(
        requestUri,
        cancelToken: requestCancellationToken,
        headers: cookies,
      );

      //if (response == null && !requestCancellationToken.isCanceled)
      //  throw ServiceRequestFailed("Http request failed!");

      _updateCookie(response);

      return response;
    } on http.OperationCanceledError catch (_) {
      throw OperationCancelledException();
    } catch (ex) {
      if (!requestCancellationToken.isCanceled) rethrow;
    } finally {
      cancellationToken.setCancellationCallback(null);
    }

    return null;
  }

  Future<Response> post(String url, dynamic data,
      [CancellationToken cancellationToken]) async {
    if (cancellationToken == null) cancellationToken = CancellationToken();
    var requestCancellationToken = http.CancellationToken();

    try {
      cancellationToken.setCancellationCallback(() {
        requestCancellationToken.cancel();
      });

      var response = await http.HttpClientHelper.post(
        url,
        body: data,
        headers: cookies,
        cancelToken: requestCancellationToken,
      );

      _updateCookie(response);
      return response;
    } finally {
      cancellationToken.setCancellationCallback(null);
    }
  }

  void _updateCookie(Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      cookies['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}
