import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_result.dart';
import 'package:dhbwstudentapp/schedule/service/rapla/rapla_monthly_response_parser.dart';
import 'package:html/dom.dart';

class RaplaSeveralMonthsResponseParser {
  static ScheduleQueryResult parseSeveralMonthlyTables(
    Document document,
    List<Element> monthTables,
  ) {
    var parseErrors = <ParseError>[];
    var allEntries = <ScheduleEntry>[];

    for (var monthTable in monthTables) {
      var result = RaplaMonthlyResponseParser.parseMonthlyTable(monthTable);

      parseErrors.addAll(result.errors);
      allEntries.addAll(result.schedule.entries);
    }

    return ScheduleQueryResult(Schedule.fromList(allEntries), parseErrors);
  }
}
