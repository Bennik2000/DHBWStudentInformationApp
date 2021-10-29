import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_result.dart';
import 'package:dhbwstudentapp/schedule/service/rapla/rapla_parsing_utils.dart';
import 'package:html/dom.dart';
import 'package:intl/intl.dart';

///
/// Implements the parsing of the rapla service when the response is a week
/// table
///
class RaplaWeekResponseParser {
  static ScheduleQueryResult parseWeeklyTable(
    Document document,
    Element weekTable,
  ) {
    var dates = _readDatesFromHeadersOrThrow(document);
    var allRows = weekTable.getElementsByTagName("tr");

    var allEntries = <ScheduleEntry>[];
    var parseErrors = <ParseError>[];

    for (var row in allRows) {
      var currentDayInWeekIndex = 0;
      for (var cell in row.children) {
        if (cell.localName != "td") continue;

        // Skip all spacer cells. They are only used for the alignment in the html page
        if (cell.classes.contains("week_number")) continue;
        if (cell.classes.contains("week_header")) continue;
        if (cell.classes.contains("week_smallseparatorcell")) continue;
        if (cell.classes.contains("week_smallseparatornolinecell")) continue;
        if (cell.classes.contains("week_smallseparatorcell_black")) continue;
        if (cell.classes.contains("week_emptycell_black")) continue;
        if (cell.classes.contains("week_emptynolinecell")) continue;

        // The week_separatorcell and week_separatorcell_black cell types mark
        // the end of a column
        if (cell.classes.contains("week_separatorcell_black") ||
            cell.classes.contains("week_separatorcell") ||
            cell.classes.contains("week_separatornolinecell")) {
          currentDayInWeekIndex = currentDayInWeekIndex + 1;
          continue;
        }

        assert(currentDayInWeekIndex < dates.length + 1);

        // The important information is inside a week_block cell
        if (cell.classes.contains("week_block")) {
          try {
            var entry = RaplaParsingUtils.extractScheduleEntryOrThrow(
              cell,
              dates[currentDayInWeekIndex],
            );

            allEntries.add(entry);
          } catch (exception, trace) {
            parseErrors.add(ParseError(exception, trace));
          }
        }
      }
    }

    allEntries.sort(
      (ScheduleEntry e1, ScheduleEntry e2) => e1?.start?.compareTo(e2?.start),
    );

    return ScheduleQueryResult(
      Schedule.fromList(allEntries),
      parseErrors,
    );
  }

  static List<DateTime> _readDatesFromHeadersOrThrow(Document document) {
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

  static String _readYearOrThrow(Document document) {
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
              (entry.attributes["selected"] == "" ||
                  entry.attributes["selected"] == "selected")) {
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
