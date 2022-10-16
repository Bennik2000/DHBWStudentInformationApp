import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_result.dart';
import 'package:dhbwstudentapp/schedule/service/rapla/rapla_several_months_response_parser.dart';
import 'package:dhbwstudentapp/schedule/service/rapla/rapla_week_response_parser.dart';
import 'package:html/parser.dart' show parse;

///
/// Parsing implementation which parses the response of the rapla schedule source.
///
class RaplaResponseParser {
  RaplaResponseParser();

  ScheduleQueryResult parseSchedule(String responseBody) {
    final document = parse(responseBody);

    final weekTable = document.getElementsByClassName("week_table");
    final monthTable = document.getElementsByClassName("month_table");

    if (weekTable.isNotEmpty) {
      return RaplaWeekResponseParser.parseWeeklyTable(
        document,
        weekTable[0],
      );
    } else if (monthTable.isNotEmpty) {
      return RaplaSeveralMonthsResponseParser.parseSeveralMonthlyTables(
        document,
        monthTable,
      );
    }

    return ScheduleQueryResult(const Schedule(), [
      ParseError("Did not find a week_table and month_table class"),
    ]);
  }
}
