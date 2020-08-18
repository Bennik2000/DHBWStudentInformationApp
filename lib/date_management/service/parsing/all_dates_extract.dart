import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
// TODO: Parse exception to common module

class AllDatesExtract {
  List<DateEntry> extractAllDates(String body) {
    try {
      return _extractAllDates(body);
    } catch (e) {
      if (e.runtimeType is ParseException) rethrow;
      throw new ParseException.withInner(e);
    }
  }

  List<DateEntry> _extractAllDates(String body) {
    var document = parse(body);

    // The dates are located in the first <p> element of the page
    var dateContainingElement = document.getElementsByTagName("p")[0];

    var dateEntries = <DateEntry>[];

    for (var a in dateContainingElement.nodes.sublist(2)) {
      var text = a.text;

      var dateEntry = _parseDateEntryLine(text);

      if (dateEntry != null) {
        dateEntries.add(dateEntry);
      }
    }

    return dateEntries;
  }

  DateEntry _parseDateEntryLine(String line) {
    var parts = line.split(';');

    if (parts.length != 5) {
      return null;
    }

    return DateEntry(
        comment: parts[4].trim(),
        description: parts[0].trim(),
        year: parts[1].trim(),
        dateAndTime: _parseDateTime(
          parts[2].trim(),
          parts[3].trim(),
        ));
  }

  DateTime _parseDateTime(String date, String time) {
    var dateAndTimeString = date + " " + time;

    try {
      return DateFormat("dd.MM.yyyy hh:mm").parse(dateAndTimeString);
    } on FormatException catch (_) {
      return null;
    }
  }
}
