import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_result.dart';
import 'package:dhbwstudentapp/schedule/service/rapla/rapla_parsing_utils.dart';
import 'package:html/dom.dart';

///
/// Implements the parsing of the rapla service when the response is a month
/// table
///
class RaplaMonthlyResponseParser {
  static ScheduleQueryResult parseMonthlyTable(
    Element monthTable,
  ) {
    final title = monthTable.parent!.getElementsByClassName("title");

    final monthAndYear = title[0].text;
    final yearString = monthAndYear.split(" ")[1];
    final year = int.tryParse(yearString);
    final month = _monthStringToDateTime(monthAndYear);

    final dayCells = monthTable.getElementsByClassName("month_cell");

    final allEntries = <ScheduleEntry>[];
    final parseErrors = <ParseError>[];

    for (final dayCell in dayCells) {
      final dayNumber = dayCell.getElementsByTagName("div");
      final dayEntries = dayCell.getElementsByClassName("month_block");

      if (dayNumber.isEmpty || dayEntries.isEmpty) continue;

      final dayNumberString = dayNumber[0].text;
      final day = int.tryParse(dayNumberString);

      for (final dayEntry in dayEntries) {
        try {
          final entry = RaplaParsingUtils.extractScheduleEntryOrThrow(
            dayEntry,
            DateTime(year!, month!, day!),
          );

          allEntries.add(entry);
        } catch (exception, trace) {
          parseErrors.add(ParseError(exception, trace));
        }
      }
    }

    return ScheduleQueryResult(Schedule.fromList(allEntries), parseErrors);
  }

  static int? _monthStringToDateTime(String monthAndYear) {
    final monthString = monthAndYear.split(" ")[0];
    final monthNames = {
      "Januar": DateTime.january,
      "Februar": DateTime.february,
      "März": DateTime.march,
      "April": DateTime.april,
      "Mai": DateTime.may,
      "Juni": DateTime.june,
      "Juli": DateTime.july,
      "August": DateTime.august,
      "September": DateTime.september,
      "Oktober": DateTime.october,
      "November": DateTime.november,
      "Dezember": DateTime.december,
    };

    final month = monthNames[monthString];
    return month;
  }
}
