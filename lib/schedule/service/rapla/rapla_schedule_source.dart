import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/common/util/date_utils.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/service/rapla/rapla_response_parser.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart' as http;

class RaplaScheduleSource extends ScheduleSource {
  final RaplaResponseParser responseParser = new RaplaResponseParser();

  String raplaUrl;

  RaplaScheduleSource({this.raplaUrl});

  void setEndpointUrl(String url) {
    raplaUrl = url;
  }

  @override
  Future<Schedule> querySchedule(DateTime from, DateTime to,
      [CancellationToken cancellationToken]) async {
    DateTime current = toDayOfWeek(from, DateTime.monday);

    if (cancellationToken == null) cancellationToken = CancellationToken();

    var schedule = Schedule();

    while (to.isAfter(current) && !cancellationToken.isCancelled()) {
      try {
        var weekSchedule = await _fetchRaplaSource(current, cancellationToken);
        if (weekSchedule != null) schedule.merge(weekSchedule);
      } on OperationCancelledException {
        rethrow;
      } catch (e, trace) {
        throw ScheduleQueryFailedException(e, trace);
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

    bool hasKeyParameter = uri.queryParameters.containsKey("key");
    bool hasUserParameter = uri.queryParameters.containsKey("user");
    bool hasFileParameter = uri.queryParameters.containsKey("file");
    bool hasPageParameter = uri.queryParameters.containsKey("page");

    Map<String, String> parameters = {};

    if (hasKeyParameter) {
      parameters["key"] = uri.queryParameters["key"];
    } else {
      if (hasUserParameter) parameters["user"] = uri.queryParameters["user"];
      if (hasFileParameter) parameters["file"] = uri.queryParameters["file"];
      if (hasPageParameter) parameters["page"] = uri.queryParameters["page"];
    }

    parameters["day"] = date.day.toString();
    parameters["month"] = date.month.toString();
    parameters["year"] = date.year.toString();

    var requestUri = Uri.https(uri.authority, uri.path, parameters);

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

  @override
  void validateEndpointUrl(String url) {
    Uri uri;

    try {
      uri = Uri.parse(url);
    } catch (e) {
      throw EndpointUrlInvalid();
    }

    if (uri != null) {
      bool hasKeyParameter = uri.queryParameters.containsKey("key");
      bool hasUserParameter = uri.queryParameters.containsKey("user");
      bool hasFileParameter = uri.queryParameters.containsKey("file");
      bool hasPageParameter = uri.queryParameters.containsKey("page");

      if (hasUserParameter && hasFileParameter && hasPageParameter) {
        return;
      }

      if (hasKeyParameter) {
        return;
      }

      throw EndpointUrlInvalid();
    }
  }
}
