import 'dart:convert';

import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_result.dart';
import 'package:dhbwstudentapp/schedule/service/ical/ical_parser.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart' as http;

class IcalScheduleSource extends ScheduleSource {
  final IcalParser _icalParser = IcalParser();
  String? _url;

  void setIcalUrl(String? url) {
    _url = url;
  }

  @override
  bool canQuery() {
    return isValidUrl(_url);
  }

  @override
  Future<ScheduleQueryResult?> querySchedule(
    DateTime? from,
    DateTime? to, [
    CancellationToken? cancellationToken,
  ]) async {
    var response = await _makeRequest(_url!, cancellationToken!);
    if (response == null) return null;

    try {
      var body = utf8.decode(response.bodyBytes);
      var schedule = _icalParser.parseIcal(body);

      return ScheduleQueryResult(
        schedule.schedule.trim(from, to),
        schedule.errors,
      );
    } on ParseException catch (_) {
      rethrow;
    } catch (exception, trace) {
      throw ParseException.withInner(exception, trace);
    }
  }

  Future<Response?> _makeRequest(
      String url, CancellationToken cancellationToken) async {
    url = url.replaceAll("webcal://", "https://");

    var requestCancellationToken = http.CancellationToken();

    try {
      cancellationToken.setCancellationCallback(() {
        requestCancellationToken.cancel();
      });

      var response = await http.HttpClientHelper.get(
        Uri.parse(url),
        cancelToken: requestCancellationToken,
      );

      if (response == null && !requestCancellationToken.isCanceled)
        throw ServiceRequestFailed("Http request failed!");

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

  static bool isValidUrl(String? url) {
    try {
      if (url == null) return false;
      Uri.parse(url);
    } catch (e) {
      return false;
    }

    return true;
  }
}
