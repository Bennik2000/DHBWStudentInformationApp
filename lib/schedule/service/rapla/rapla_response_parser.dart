import 'package:dhbwstuttgart/common/util/string_utils.dart';
import 'package:dhbwstuttgart/schedule/model/schedule.dart';
import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
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
    var weekBlocks = document.getElementsByClassName(WEEK_BLOCK_CLASS);

    for (var value in weekBlocks) {
      var tooltip = value.getElementsByClassName(TOOLTIP_CLASS);
      if (tooltip.length != 1) continue;

      var start = _parseStart(tooltip[0].children[1].innerHtml);
      var end = _parseEnd(tooltip[0].children[1].innerHtml);
      var title = "";
      var details = "";
      var professor = "";

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

      schedule.addEntry(scheduleEntry);
    }

    return schedule;
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

  DateTime _parseStart(String dateString) {
    var date = _parseDate(dateString);
    var time = DateFormat("HH:mm").parse(dateString.substring(12, 17));

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  DateTime _parseEnd(String dateString) {
    var date = _parseDate(dateString);
    var time = DateFormat("HH:mm").parse(dateString.substring(18, 23));

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  DateTime _parseDate(String dateString) {
    var date = DateFormat("dd.MM.yy").parse(dateString.substring(3, 11));

    return DateTime(date.year + 2000, date.month, date.day);
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
