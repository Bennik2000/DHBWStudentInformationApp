import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_result.dart';

///
/// Parses an ICAL file extracts all schedule entries
///
class IcalParser {
  IcalParser();

  /// Matches a calendar entry. The first group contains the text between
  /// the BEGIN:VEVENT and END:VEVENT
  final String calendarEntryRegex = "BEGIN:VEVENT(.*?)END:VEVENT";

  /// Matches a property in the form of:
  /// KEY:Value
  /// or:
  /// DTSTAMP;VALUE=DATE-TIME:20201008T000006Z
  final String propertyRegex = r"([^;:\n\r\s]+)(;[^:]*)?:(.*)";

  /// Matches the date time format:
  /// YYYYMMDDTHHmmss
  final String dateTimeRegex =
      "([0-9]{4})([0-9]{2})([0-9]{2})T([0-9]{2})([0-9]{2})([0-9]{2})(Z?)";

  ScheduleQueryResult parseIcal(String icalData) {
    final regex = RegExp(
      calendarEntryRegex,
      multiLine: true,
      unicode: true,
      dotAll: true,
    );

    final matches = regex.allMatches(icalData);

    final List<ScheduleEntry> entries = [];

    for (final match in matches) {
      final entry = _parseEntry(match.group(1)!);
      entries.add(entry);
    }

    return ScheduleQueryResult(
      Schedule(entries: entries),
      [],
    );
  }

  ScheduleEntry _parseEntry(String entryData) {
    final allProperties = RegExp(
      propertyRegex,
      unicode: true,
    ).allMatches(entryData);

    final Map<String?, String?> properties = {};

    for (final property in allProperties) {
      properties[property.group(1)] = property.group(3);
    }

    return ScheduleEntry(
      start: _parseDate(properties["DTSTART"]),
      end: _parseDate(properties["DTEND"]),
      room: properties["LOCATION"],
      title: properties["SUMMARY"],
      type: ScheduleEntryType.Lesson,
      details: properties["DESCRIPTION"] ?? "",
      professor: "",
    );
  }

  DateTime? _parseDate(String? date) {
    if (date == null) return null;

    final match = RegExp(
      dateTimeRegex,
      unicode: true,
    ).firstMatch(date);

    if (match == null) return null;

    return DateTime(
      int.tryParse(match.group(1)!)!,
      int.tryParse(match.group(2)!)!,
      int.tryParse(match.group(3)!)!,
      int.tryParse(match.group(4)!)!,
      int.tryParse(match.group(5)!)!,
      int.tryParse(match.group(6)!)!,
    );
  }
}
