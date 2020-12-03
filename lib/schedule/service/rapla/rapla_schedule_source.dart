import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/common/util/date_utils.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_result.dart';
import 'package:dhbwstudentapp/schedule/service/rapla/rapla_response_parser.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart' as http;

class RaplaScheduleSource extends ScheduleSource {
  final RaplaResponseParser responseParser = RaplaResponseParser();

  String raplaUrl;

  RaplaScheduleSource({this.raplaUrl});

  void setEndpointUrl(String url) {
    raplaUrl = url;
  }

  @override
  Future<ScheduleQueryResult> querySchedule(DateTime from, DateTime to,
      [CancellationToken cancellationToken]) async {
    DateTime current = toDayOfWeek(from, DateTime.monday);

    if (cancellationToken == null) cancellationToken = CancellationToken();

    var schedule = Schedule();
    var allErrors = <ParseError>[];

    var didChangeMonth = false;

    while ((to.isAfter(current) && !cancellationToken.isCancelled()) ||
        didChangeMonth) {
      try {
        var weekSchedule = await _fetchRaplaSource(current, cancellationToken);

        if (weekSchedule.schedule != null)
          schedule.merge(weekSchedule.schedule);

        allErrors.addAll(weekSchedule.errors ?? []);
      } on OperationCancelledException {
        rethrow;
      } on ParseException catch (ex, trace) {
        allErrors.add(ParseError(ex, trace));
      } catch (e, trace) {
        throw ScheduleQueryFailedException(e, trace);
      }

      var currentMonth = current.month;
      current = toNextWeek(current);
      var nextMonth = current.month;

      // Some rapla instances only return the dates in the current month.
      // If the month changes in the middle of a week only half the week is
      // queried. Thus, if the month changes try to query the second half of the
      // week which is in a different month
      didChangeMonth = currentMonth != nextMonth;
    }

    if (cancellationToken.isCancelled()) throw OperationCancelledException();

    schedule = schedule.trim(from, to);

    return ScheduleQueryResult(schedule, allErrors);
  }

  Future<ScheduleQueryResult> _fetchRaplaSource(
    DateTime date,
    CancellationToken cancellationToken,
  ) async {
    var requestUri = _buildRequestUri(date);

    var response = await _makeRequest(requestUri, cancellationToken);
    if (response == null) return null;

    try {
      var schedule = responseParser.parseSchedule(response.body);

      if (schedule?.schedule?.urls != null) {
        schedule.schedule.urls.add(requestUri.toString());
      }

      return schedule;
    } on ParseException catch (_) {
      rethrow;
    } catch (exception, trace) {
      throw ParseException.withInner(exception, trace);
    }
  }

  Uri _buildRequestUri(DateTime date) {
    if (!raplaUrl.startsWith("http://") && !raplaUrl.startsWith("https://")) {
      raplaUrl = "http://$raplaUrl";
    }

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

    if (raplaUrl.startsWith("https")) {
      return Uri.https(uri.authority, uri.path, parameters);
    } else {
      return Uri.http(uri.authority, uri.path, parameters);
    }
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
  bool canQuery() {
    return isValidUrl(raplaUrl);
  }

  static bool isValidUrl(String url) {
    Uri uri;

    try {
      uri = Uri.parse(url);
    } catch (e) {
      return false;
    }

    if (uri != null) {
      bool hasKeyParameter = uri.queryParameters.containsKey("key");
      bool hasUserParameter = uri.queryParameters.containsKey("user");
      bool hasFileParameter = uri.queryParameters.containsKey("file");
      bool hasPageParameter = uri.queryParameters.containsKey("page");

      if (hasUserParameter && hasFileParameter && hasPageParameter) {
        return true;
      }

      if (hasKeyParameter) {
        return true;
      }
    }

    return false;
  }
}

enum FailureReason {
  Success,
  RequestError,
  ParseError,
}

class ScheduleOrFailure {
  final FailureReason reason;
  final Schedule schedule;
  final Object exception;
  final StackTrace trace;

  bool get success => reason == FailureReason.Success;

  ScheduleOrFailure.success(this.schedule)
      : reason = FailureReason.Success,
        exception = null,
        trace = null;

  ScheduleOrFailure.failParseError(this.exception, this.trace)
      : reason = FailureReason.ParseError,
        schedule = null;

  ScheduleOrFailure.failRequestError(this.exception, this.trace)
      : reason = FailureReason.RequestError,
        schedule = null;
}
