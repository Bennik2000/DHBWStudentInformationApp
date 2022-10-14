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

  RaplaScheduleSource({required this.raplaUrl});

  @override
  Future<ScheduleQueryResult> querySchedule(
    DateTime? from,
    DateTime? to, [
    CancellationToken? cancellationToken,
  ]) async {
    DateTime current = toDayOfWeek(from, DateTime.monday)!;

    cancellationToken ??= CancellationToken();

    var schedule = Schedule();
    final allErrors = <ParseError>[];

    var didChangeMonth = false;

    while ((to!.isAfter(current) && !cancellationToken.isCancelled) ||
        didChangeMonth) {
      try {
        final weekSchedule =
            await _fetchRaplaSource(current, cancellationToken);

        if (weekSchedule?.schedule != null) {
          schedule.merge(weekSchedule!.schedule);
        }

        if (weekSchedule != null) {
          allErrors.addAll(weekSchedule.errors);
        }
      } on OperationCancelledException {
        rethrow;
      } on ParseException catch (ex, trace) {
        allErrors.add(ParseError(ex, trace));
      } catch (e, trace) {
        throw ScheduleQueryFailedException(e, trace);
      }

      final currentMonth = current.month;
      current = toNextWeek(current)!;
      final nextMonth = current.month;

      // Some rapla instances only return the dates in the current month.
      // If the month changes in the middle of a week only half the week is
      // queried. Thus, if the month changes try to query the second half of the
      // week which is in a different month
      didChangeMonth = currentMonth != nextMonth;
    }

    cancellationToken.throwIfCancelled();

    schedule = schedule.trim(from, to);

    return ScheduleQueryResult(schedule, allErrors);
  }

  Future<ScheduleQueryResult?> _fetchRaplaSource(
    DateTime date,
    CancellationToken cancellationToken,
  ) async {
    final requestUri = _buildRequestUri(date);

    final response = await _makeRequest(requestUri, cancellationToken);
    if (response == null) return null;

    try {
      final schedule = responseParser.parseSchedule(response.body);

      schedule.schedule.urls.add(requestUri.toString());

      return schedule;
    } on ParseException catch (_) {
      rethrow;
    } catch (exception, trace) {
      throw ParseException.withInner(exception, trace);
    }
  }

  ///
  /// There are several valid url formats depending on the rapla configuration
  /// which is used.
  /// Possible formats are:
  /// - <rapla_url>?key=XXXXXXXXXX
  /// - <rapla_url>?key=XXXXXXXXXX&salt=XXXXX&allocatable_id=XXXXXX
  /// - <rapla_url>?user=XXXXXXXXXX&file=XXXXX&page=XXXXXX
  ///
  Uri _buildRequestUri(DateTime date) {
    if (!raplaUrl.startsWith("http://") && !raplaUrl.startsWith("https://")) {
      raplaUrl = "http://$raplaUrl";
    }

    final uri = Uri.parse(raplaUrl);

    final bool hasKeyParameter = uri.queryParameters.containsKey("key");
    final bool hasUserParameter = uri.queryParameters.containsKey("user");
    final bool hasFileParameter = uri.queryParameters.containsKey("file");
    final bool hasPageParameter = uri.queryParameters.containsKey("page");

    final bool hasAllocatableId =
        uri.queryParameters.containsKey("allocatable_id");
    final bool hasSalt = uri.queryParameters.containsKey("salt");

    final Map<String, String?> parameters = {};

    if (hasKeyParameter) {
      parameters["key"] = uri.queryParameters["key"];

      if (hasAllocatableId) {
        parameters["allocatable_id"] = uri.queryParameters["allocatable_id"];
      }
      if (hasSalt) parameters["salt"] = uri.queryParameters["salt"];
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

  Future<Response?> _makeRequest(
    Uri uri,
    CancellationToken cancellationToken,
  ) async {
    final requestCancellationToken = http.CancellationToken();

    try {
      cancellationToken.cancellationCallback = requestCancellationToken.cancel;

      final response = await http.HttpClientHelper.get(
        uri,
        cancelToken: requestCancellationToken,
      );

      if (response == null && !requestCancellationToken.isCanceled) {
        throw ServiceRequestFailed("Http request failed!");
      }

      return response;
    } on http.OperationCanceledError catch (_) {
      throw OperationCancelledException();
    } catch (ex) {
      if (!requestCancellationToken.isCanceled) rethrow;
    } finally {
      cancellationToken.cancellationCallback = null;
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

    final bool hasKeyParameter = uri.queryParameters.containsKey("key");
    final bool hasUserParameter = uri.queryParameters.containsKey("user");
    final bool hasFileParameter = uri.queryParameters.containsKey("file");
    final bool hasPageParameter = uri.queryParameters.containsKey("page");

    final bool hasAllocatableId =
        uri.queryParameters.containsKey("allocatable_id");
    final bool hasSalt = uri.queryParameters.containsKey("salt");

    if (hasUserParameter && hasFileParameter && hasPageParameter) {
      return true;
    }

    if (hasSalt && hasAllocatableId && hasKeyParameter) {
      return true;
    }

    if (hasKeyParameter) {
      return true;
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
  final Schedule? schedule;
  final Object? exception;
  final StackTrace? trace;

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
