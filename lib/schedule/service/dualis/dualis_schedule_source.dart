import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/common/util/date_utils.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_scraper.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_result.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';

class DualisScheduleSource extends ScheduleSource {
  final DualisScraper _dualisScraper;

  DualisScheduleSource(this._dualisScraper);

  @override
  Future<ScheduleQueryResult> querySchedule(DateTime? from, DateTime? to,
      [CancellationToken? cancellationToken,]) async {
    if (cancellationToken == null) cancellationToken = CancellationToken();

    DateTime current = toStartOfMonth(from)!;

    var schedule = Schedule();
    var allErrors = <ParseError>[];

    if (!_dualisScraper.isLoggedIn())
      await _dualisScraper.loginWithPreviousCredentials(cancellationToken);

    while (to!.isAfter(current) && !cancellationToken.isCancelled()) {
      try {
        var monthSchedule = await _dualisScraper.loadMonthlySchedule(
            current, cancellationToken,);

        schedule.merge(monthSchedule);
      } on OperationCancelledException {
        rethrow;
      } on ParseException catch (ex, trace) {
        allErrors.add(ParseError(ex, trace));
      } catch (e, trace) {
        print(trace);
        throw ScheduleQueryFailedException(e, trace);
      }

      current = toNextMonth(current);
    }

    if (cancellationToken.isCancelled()) throw OperationCancelledException();

    schedule = schedule.trim(from, to);

    return ScheduleQueryResult(schedule, allErrors);
  }

  Future<void> setLoginCredentials(Credentials credentials) async {
    _dualisScraper.setLoginCredentials(credentials);
  }

  @override
  bool canQuery() {
    return _dualisScraper.isLoggedIn();
  }
}
