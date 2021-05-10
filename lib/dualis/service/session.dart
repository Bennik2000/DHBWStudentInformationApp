import 'dart:convert';

import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart' as http;

///
/// Handles cookies and provides a session. Execute your api calls with the
/// provided get and set methods.
///
class Session {
  Map<String, String> cookies = {};

  ///
  /// Execute a GET request and return the result body as string
  ///
  Future<String> get(
    String url, [
    CancellationToken cancellationToken,
  ]) async {
    var response = await rawGet(url, cancellationToken);

    if (response == null) {
      return null;
    }

    try {
      return utf8.decode(response.bodyBytes);
    } on FormatException catch (_) {
      return latin1.decode(response.bodyBytes);
    }
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

      if (response == null && !requestCancellationToken.isCanceled)
        throw ServiceRequestFailed("Http request failed!");

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

  ///
  /// Execute a POST request and return the result body as string
  ///
  Future<String> post(
    String url,
    dynamic data, [
    CancellationToken cancellationToken,
  ]) async {
    var response = await rawPost(url, data, cancellationToken);

    if (response == null) {
      return null;
    }

    try {
      return utf8.decode(response.bodyBytes);
    } on FormatException catch (_) {
      return latin1.decode(response.bodyBytes);
    }
  }

  Future<Response> rawPost(
    String url,
    dynamic data, [
    CancellationToken cancellationToken,
  ]) async {
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

      if (response == null && !requestCancellationToken.isCanceled)
        throw ServiceRequestFailed("Http request failed!");

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

  void _updateCookie(Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');

      var cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);

      cookie = cookie.replaceAll(" ", "");

      cookies['cookie'] = cookie;
    }
  }
}
