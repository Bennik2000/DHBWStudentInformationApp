import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_result.dart';
import 'package:dhbwstudentapp/schedule/service/rapla/rapla_parsing_utils.dart';
import 'package:html/dom.dart';

///
/// Implements the parsing of the rapla service when the response is a week
/// table
///
class RaplaWeekResponseParser {
  static ScheduleQueryResult parseWeeklyTable(
    Element weekTable,
    List<DateTime> dates,
  ) {
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
        if (cell.classes.contains("week_smallseparatorcell_black")) continue;
        if (cell.classes.contains("week_emptycell_black")) continue;

        // The week_separatorcell and week_separatorcell_black cell types mark
        // the end of a column
        if (cell.classes.contains("week_separatorcell_black") ||
            cell.classes.contains("week_separatorcell")) {
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
}
