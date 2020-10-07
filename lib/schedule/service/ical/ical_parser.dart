import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_result.dart';

///
/// Parses an ICAL file extracts all schedule entries
///
class IcalParser {
  /// Matches a calendar entry. The first group contains the text between
  /// the BEGIN:VEVENT and END:VEVENT
  final RegExp calendarEntryRegex = RegExp(
    "BEGIN:VEVENT(.*?)END:VEVENT",
    multiLine: true,
    unicode: true,
    dotAll: true,
  );

  /// Matches a property in the form of:
  /// KEY:Value
  final RegExp propertyRegex = RegExp("([A-Z]+):(.*)");

  /// Matches the date time format:
  /// YYYYMMDDTHHmmss
  final RegExp dateTimeRegex =
      RegExp("([0-9]{4})([0-9]{2})([0-9]{2})T([0-9]{2})([0-9]{2})([0-9]{2})");

  ScheduleQueryResult parseIcal(String icalData) {
    var matches = calendarEntryRegex.allMatches(icalData);

    List<ScheduleEntry> entries = [];

    for (var match in matches) {
      var entry = _parseEntry(match.group(1));
      entries.add(entry);
    }

    return ScheduleQueryResult(
      Schedule.fromList(entries),
      [],
    );
  }

  ScheduleEntry _parseEntry(String entryData) {
    var allProperties = propertyRegex.allMatches(entryData);

    Map<String, String> properties = {};

    for (var property in allProperties) {
      properties[property.group(1)] = property.group(2);
    }

    return ScheduleEntry(
      start: _parseDate(properties["DTSTART"]),
      end: _parseDate(properties["DTEND"]),
      room: properties["LOCATION"],
      title: properties["SUMMARY"],
      type: ScheduleEntryType.Class,
      details: "",
      professor: "",
    );
  }

  DateTime _parseDate(String date) {
    var match = dateTimeRegex.firstMatch(date);

    if (match == null) {
      return null;
    }

    return DateTime(
      int.tryParse(match.group(1)),
      int.tryParse(match.group(2)),
      int.tryParse(match.group(3)),
      int.tryParse(match.group(4)),
      int.tryParse(match.group(5)),
      int.tryParse(match.group(6)),
    );
  }
}
