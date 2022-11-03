import 'dart:convert';

import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart' as http;

// TODO: [Leptopoda] requestCancellationToken and Cancellation token cleanup
// TODO: [Leptopoda] Pass Uri objects and not strings

///
/// Handles cookies and provides a session. Execute your api calls with the
/// provided get and set methods.
///
class Session {
  Map<String, String> _cookies = {};

  ///
  /// Execute a GET request and return the result body as string
  ///
  Future<String?> get(
    String url, [
    CancellationToken? cancellationToken,
  ]) async {
    final response = await rawGet(url, cancellationToken);

    if (response == null) {
      return null;
    }

    try {
      return utf8.decode(response.bodyBytes);
    } on FormatException catch (_) {
      return latin1.decode(response.bodyBytes);
    }
  }

  Future<Response?> rawGet(
    String url, [
    CancellationToken? cancellationToken,
  ]) async {
    final requestCancellationToken = http.CancellationToken();
    cancellationToken ??= CancellationToken();

    try {
      cancellationToken.cancellationCallback = requestCancellationToken.cancel;

      final requestUri = Uri.parse(url);

      final response = await http.HttpClientHelper.get(
        requestUri,
        cancelToken: requestCancellationToken,
        headers: _cookies,
      );

      if (response == null && !requestCancellationToken.isCanceled) {
        throw ServiceRequestFailed("Http request failed!");
      }

      _updateCookie(response!);

      return response;
      // ignore: avoid_catching_errors
    } on http.OperationCanceledError catch (_) {
      throw OperationCancelledException();
    } catch (ex) {
      if (!requestCancellationToken.isCanceled) rethrow;
    } finally {
      cancellationToken.cancellationCallback = null;
    }

    return null;
  }

  ///
  /// Execute a POST request and return the result body as string
  ///
  Future<String?> post(
    String url,
    Map<String, String> data, [
    CancellationToken? cancellationToken,
  ]) async {
    final response = await rawPost(url, data, cancellationToken);

    if (response == null) {
      return null;
    }

    try {
      return utf8.decode(response.bodyBytes);
    } on FormatException catch (_) {
      return latin1.decode(response.bodyBytes);
    }
  }

  Future<Response?> rawPost(
    String url,
    Map<String, String> data, [
    CancellationToken? cancellationToken,
  ]) async {
    cancellationToken ??= CancellationToken();
    final requestCancellationToken = http.CancellationToken();

    try {
      cancellationToken.cancellationCallback = requestCancellationToken.cancel;

      final response = await http.HttpClientHelper.post(
        Uri.parse(url),
        body: data,
        headers: _cookies,
        cancelToken: requestCancellationToken,
      );

      if (response == null && !requestCancellationToken.isCanceled) {
        throw ServiceRequestFailed("Http request failed!");
      }

      _updateCookie(response!);

      return response;
      // ignore: avoid_catching_errors
    } on http.OperationCanceledError catch (_) {
      throw OperationCancelledException();
    } catch (ex) {
      if (!requestCancellationToken.isCanceled) rethrow;
    } finally {
      cancellationToken.cancellationCallback = null;
    }

    return null;
  }

  void _updateCookie(Response response) {
    final String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      final int index = rawCookie.indexOf(';');

      var cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);

      cookie = cookie.replaceAll(" ", "");

      _cookies['cookie'] = cookie;
    }
  }
}
