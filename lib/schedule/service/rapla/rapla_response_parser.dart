import 'package:dhbwstudentapp/common/util/string_utils.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class RaplaResponseParser {
  static const String WEEK_BLOCK_CLASS = "week_block";
  static const String TOOLTIP_CLASS = "tooltip";
  static const String INFOTABLE_CLASS = "infotable";
  static const String RESOURCE_CLASS = "resource";
  static const String LABEL_CLASS = "label";
  static const String VALUE_CLASS = "value";
  static const String CLASS_NAME_LABEL = "Veranstaltungsname:";
  static const String PROFESSOR_NAME_LABEL = "Personen:";
  static const String DETAILS_LABEL = "Bemerkung:";
  static const String TYPE_TAG_NAME = "strong";

  static const Map<String, ScheduleEntryType> entryTypeMapping = {
    "Feiertag": ScheduleEntryType.PublicHoliday,
    "Online-Format (ohne Raumbelegung)": ScheduleEntryType.Online,
    "Vorlesung / Lehrbetrieb": ScheduleEntryType.Class,
    "Klausur / Prüfung": ScheduleEntryType.Exam
  };

  Schedule parseSchedule(String responseBody) {
    var schedule = Schedule();

    var document = parse(responseBody);

    var dates = _readDatesFromHeadersOrThrow(document);

    var allRows = document.getElementsByTagName("tr");

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
          var entry = _extractScheduleEntry(cell, dates[currentDayInWeekIndex]);
          schedule.entries.add(entry);
        }
      }
    }

    return schedule;
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

      var date = DateFormat("dd.MM.yyyy").parse(dateString.substring(3));
      // TODO: Exception handling

      dates.add(date);
    }
    return dates;
  }

  String _readYearOrThrow(Document document) {
    // The only reliable way to read the year of this schedule is to parse the
    // selected year in the date selector
    var comboBoxes = document.getElementsByTagName("select");

    var year;
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
      throw ElementNotFoundParseException();
    }

    return year;
  }

  ScheduleEntry _extractScheduleEntry(Element value, DateTime date) {
    var tooltip = value.getElementsByClassName(TOOLTIP_CLASS);
    var timeAndClassName = value.getElementsByTagName("a");

    if (tooltip.length != 1) return null;
    if (timeAndClassName.length == 0) return null;

    var start = _parseTime(timeAndClassName[0].text.substring(0, 5), date);
    var end = _parseTime(timeAndClassName[0].text.substring(7, 12), date);
    var title = "";
    var details = "";
    var professor = "";

    if (start == null || end == null) return null;

    ScheduleEntryType type = _extractEntryType(tooltip);

    var infotable = tooltip[0].getElementsByClassName(INFOTABLE_CLASS);
    if (infotable.length == 1) {
      Map<String, String> properties = _parsePropertiesTable(infotable[0]);
      title = properties[CLASS_NAME_LABEL];
      professor = properties[PROFESSOR_NAME_LABEL];
      details = properties[DETAILS_LABEL];
    }

    var resource = _extractResources(value);

    var scheduleEntry = new ScheduleEntry(
      start: start,
      end: end,
      title: title,
      details: details,
      professor: professor,
      type: type,
      room: concatStringList(resource, ", "),
    );
    return scheduleEntry;
  }

  ScheduleEntryType _extractEntryType(List<Element> tooltip) {
    var type = ScheduleEntryType.Unknown;
    var strongTag = tooltip[0].getElementsByTagName(TYPE_TAG_NAME);
    if (strongTag.length == 1) {
      var typeString = strongTag[0].innerHtml;

      if (entryTypeMapping.containsKey(typeString)) {
        type = entryTypeMapping[typeString];
      }
    }
    return type;
  }

  Map<String, String> _parsePropertiesTable(Element infotable) {
    var map = Map<String, String>();
    var labels = infotable.getElementsByClassName(LABEL_CLASS);
    var values = infotable.getElementsByClassName(VALUE_CLASS);

    for (var i = 0; i < labels.length; i++) {
      map[labels[i].innerHtml] = values[i].innerHtml;
    }
    return map;
  }

  DateTime _parseTime(String timeString, DateTime date) {
    try {
      var time = DateFormat("HH:mm").parse(timeString.substring(0, 5));
      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    } catch (e) {
      return null;
    }
  }

  List<String> _extractResources(Element value) {
    var resources = value.getElementsByClassName(RESOURCE_CLASS);

    var resourcesList = <String>[];
    for (var resource in resources) {
      resourcesList.add(resource.innerHtml);
    }

    return resourcesList;
  }
}
