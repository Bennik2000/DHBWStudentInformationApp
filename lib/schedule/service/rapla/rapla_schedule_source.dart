import 'package:dhbwstuttgart/common/util/cancellation_token.dart';
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

    while (current.isBefore(to) && !cancellationToken.isCancelled()) {
      try {
        var weekSchedule = await _fetchRaplaSource(current, cancellationToken);
        if (weekSchedule != null) schedule.merge(weekSchedule);
      } catch (Exception) {}

      current = current.add(Duration(days: 7));
    }

    if (cancellationToken.isCancelled()) return null;

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
      await Future.delayed(Duration(milliseconds: 500));
      cancellationToken.setCancellationCallback(() {
        print("Cancelling request!");
        requestCancellationToken.cancel();
      });

      var response = await http.HttpClientHelper.get(uri,
          cancelToken: requestCancellationToken);

      return response;
    } on http.OperationCanceledError catch (_) {
      print("Cancelled request!");
      return null;
    } catch (ex) {
      print("Failed to make Rapla request: ");
      print(ex.toString());

      return null;
    } finally {
      cancellationToken.setCancellationCallback(null);
    }
  }
}
