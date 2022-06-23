import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
// TODO: Parse exception to common module

class AllDatesExtract {
  List<DateEntry> extractAllDates(String body, String databaseName) {
    try {
      return _extractAllDates(body, databaseName);
    } catch (e, trace) {
      if (e.runtimeType is ParseException) rethrow;
      throw ParseException.withInner(e, trace);
    }
  }

  List<DateEntry> _extractAllDates(String body, String databaseName) {
    body = body.replaceAll(new RegExp("<(br|BR)[ /]*>"), "\n");
    var document = parse(body);

    // The dates are located in the first <p> element of the page
    var dateContainingElement = document.getElementsByTagName("p")[0];

    var dateEntries = <DateEntry>[];

    for (var a in dateContainingElement.nodes.sublist(0)) {
      var text = a.text;

      var lines = text.split("\n");

      for (var line in lines) {
        var dateEntry = _parseDateEntryLine(line, databaseName);

        if (dateEntry != null) {
          dateEntries.add(dateEntry);
        }
      }
    }

    dateEntries
        .sort((DateEntry e1, DateEntry e2) => e1.start?.compareTo(e2.start));

    return dateEntries;
  }

  DateEntry _parseDateEntryLine(String line, String databaseName) {
    var parts = line.split(';');

    if (parts.length != 5) {
      return null;
    }

    var date = _parseDateTime(
      parts[2].trim(),
      parts[3].trim(),
    );

    return DateEntry(
        comment: parts[4].trim(),
        description: parts[0].trim(),
        year: parts[1].trim(),
        databaseName: databaseName,
        start: date,
        end: date);
  }

  DateTime _parseDateTime(String date, String time) {
    if (time == "24:00") {
      time = "00:00";
    }

    var dateAndTimeString = date + " " + time;

    try {
      var date = DateFormat("dd.MM.yyyy hh:mm").parse(dateAndTimeString);
      return date;
    } on FormatException catch (_) {
      return null;
    }
  }
}
