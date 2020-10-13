import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_result.dart';
import 'package:dhbwstudentapp/schedule/service/rapla/rapla_monthly_response_parser.dart';
import 'package:dhbwstudentapp/schedule/service/rapla/rapla_week_response_parser.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';

///
/// Parsing implementation which parses the response of the rapla schedule source.
///
class RaplaResponseParser {
  ScheduleQueryResult parseSchedule(String responseBody) {
    var document = parse(responseBody);

    var dates = _readDatesFromHeadersOrThrow(document);

    var weekTable = document.getElementsByClassName("week_table");
    var monthTable = document.getElementsByClassName("month_table");

    if (weekTable.isNotEmpty) {
      return RaplaWeekResponseParser.parseWeeklyTable(
        weekTable[0],
        dates,
      );
    } else if (monthTable.isNotEmpty) {
      return RaplaMonthlyResponseParser.parseMonthlyTable(
        document,
        monthTable[0],
        dates,
      );
    }

    return ScheduleQueryResult(Schedule(), [
      ParseError("Did not find a week_table and month_table class", null),
    ]);
  }

  List<DateTime> _readDatesFromHeadersOrThrow(Document document) {
    var year = _readYearOrThrow(document);

    // The only reliable way to read the dates is the table header.
    // Some schedule entries contain the dates in the description but not
    // in every case.
    var weekHeaders = document.getElementsByClassName("week_header");
    var dates = <DateTime>[];

    for (var header in weekHeaders) {
      var dateString = header.text + year;

      try {
        var date = DateFormat("dd.MM.yyyy").parse(dateString.substring(3));
        dates.add(date);
      } catch (exception, trace) {
        throw ParseException.withInner(exception, trace);
      }
    }
    return dates;
  }

  String _readYearOrThrow(Document document) {
    // The only reliable way to read the year of this schedule is to parse the
    // selected year in the date selector
    var comboBoxes = document.getElementsByTagName("select");

    String year;
    for (var box in comboBoxes) {
      if (box.attributes.containsKey("name") &&
          box.attributes["name"] == "year") {
        var entries = box.getElementsByTagName("option");

        for (var entry in entries) {
          if (entry.attributes.containsKey("selected") &&
              entry.attributes["selected"] == "") {
            year = entry.text;

            break;
          }
        }

        break;
      }
    }

    if (year == null) {
      throw ElementNotFoundParseException("year");
    }

    return year;
  }
}
