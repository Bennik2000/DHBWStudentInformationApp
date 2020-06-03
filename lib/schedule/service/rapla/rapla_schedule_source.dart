import 'package:dhbwstuttgart/common/util/cancellation_token.dart';
import 'package:dhbwstuttgart/common/util/date_utils.dart';
import 'package:dhbwstuttgart/schedule/model/schedule.dart';
import 'package:dhbwstuttgart/schedule/service/rapla/rapla_response_parser.dart';
import 'package:dhbwstuttgart/schedule/service/schedule_source.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart' as http;

class RaplaScheduleSource extends ScheduleSource {
  final String raplaUrl;
  final RaplaResponseParser responseParser = new RaplaResponseParser();

  RaplaScheduleSource(this.raplaUrl);

  @override
  Future<Schedule> querySchedule(DateTime from, DateTime to,
      [CancellationToken cancellationToken]) async {
    DateTime current = from;

    if (cancellationToken == null) cancellationToken = CancellationToken();

    var schedule = Schedule();

    while (to.isAfter(current) && !cancellationToken.isCancelled()) {
      try {
        var weekSchedule = await _fetchRaplaSource(current, cancellationToken);
        if (weekSchedule != null) schedule.merge(weekSchedule);
      } on OperationCancelledException {
        rethrow;
      } catch (e) {
        throw ScheduleQueryFailedException(e);
      }

      current = toNextWeek(current);
    }

    if (cancellationToken.isCancelled()) throw OperationCancelledException();

    return schedule.trim(from, to);
  }

  Future<Schedule> _fetchRaplaSource(
      DateTime date, CancellationToken cancellationToken) async {
    var requestUri = _buildRequestUri(date);

    var response = await _makeRequest(requestUri, cancellationToken);
    if (response == null) return null;

    return responseParser.parseSchedule(response.body);
  }

  Uri _buildRequestUri(DateTime date) {
    var uri = Uri.parse(raplaUrl);
    var keyParameter = uri.queryParameters["key"];

    var requestUri = Uri.https(uri.authority, uri.path, {
      "key": keyParameter,
      "day": date.day.toString(),
      "month": date.month.toString(),
      "year": date.year.toString()
    });
    return requestUri;
  }

  Future<Response> _makeRequest(
      Uri uri, CancellationToken cancellationToken) async {
    var requestCancellationToken = http.CancellationToken();

    try {
      cancellationToken.setCancellationCallback(() {
        requestCancellationToken.cancel();
      });

      var response = await http.HttpClientHelper.get(uri,
          cancelToken: requestCancellationToken);

      if (response == null)
        throw ScheduleQueryFailedException("Http request failed!");

      return response;
    } on http.OperationCanceledError catch (_) {
      rethrow;
    } catch (ex) {
      rethrow;
    } finally {
      cancellationToken.setCancellationCallback(null);
    }
  }
}
