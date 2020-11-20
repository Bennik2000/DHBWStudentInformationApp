import 'package:dhbwstudentapp/common/util/string_utils.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:html/dom.dart';
import 'package:intl/intl.dart';

class RaplaParsingUtils {
  static const String WEEK_BLOCK_CLASS = "week_block";
  static const String TOOLTIP_CLASS = "tooltip";
  static const String INFOTABLE_CLASS = "infotable";
  static const String RESOURCE_CLASS = "resource";
  static const String LABEL_CLASS = "label";
  static const String VALUE_CLASS = "value";
  static const String CLASS_NAME_LABEL = "Veranstaltungsname:";
  static const String CLASS_TITLE_LABEL = "Titel:";
  static const String PROFESSOR_NAME_LABEL = "Personen:";
  static const String DETAILS_LABEL = "Bemerkung:";

  static const Map<String, ScheduleEntryType> entryTypeMapping = {
    "Feiertag": ScheduleEntryType.PublicHoliday,
    "Online-Format (ohne Raumbelegung)": ScheduleEntryType.Online,
    "Vorlesung / Lehrbetrieb": ScheduleEntryType.Class,
    "Lehrveranstaltung": ScheduleEntryType.Class,
    "Klausur / Prüfung": ScheduleEntryType.Exam,
    "Prüfung": ScheduleEntryType.Exam
  };

  static ScheduleEntry extractScheduleEntryOrThrow(
      Element value, DateTime date) {
    // The tooltip tag contains the most relevant information
    var tooltip = value.getElementsByClassName(TOOLTIP_CLASS);

    // The only reliable way to extract the time
    var timeAndClassName = value.getElementsByTagName("a");

    if (tooltip.isEmpty)
      throw ElementNotFoundParseException("tooltip container");

    if (timeAndClassName.isEmpty)
      throw ElementNotFoundParseException("time and date container");

    var start = _parseTime(timeAndClassName[0].text.substring(0, 5), date);
    var end = _parseTime(timeAndClassName[0].text.substring(7, 12), date);

    if (start == null || end == null)
      throw ElementNotFoundParseException("start and end date container");

    var title = "";
    var details = "";
    var professor = "";

    ScheduleEntryType type = _extractEntryType(tooltip);

    var infotable = tooltip[0].getElementsByClassName(INFOTABLE_CLASS);

    if (infotable.isEmpty)
      throw ElementNotFoundParseException("infotable container");

    Map<String, String> properties = _parsePropertiesTable(infotable[0]);
    title = properties[CLASS_NAME_LABEL] ?? properties[CLASS_TITLE_LABEL];
    professor = properties[PROFESSOR_NAME_LABEL];
    details = properties[DETAILS_LABEL];

    if (title == null) throw ElementNotFoundParseException("title");

    if (professor?.endsWith(",") ?? false) {
      professor = professor.substring(0, professor.length - 1);
    }

    var resource = _extractResources(value);

    var scheduleEntry = ScheduleEntry(
      start: start,
      end: end,
      title: trimAndEscapeString(title),
      details: trimAndEscapeString(details),
      professor: trimAndEscapeString(professor),
      type: type,
      room: trimAndEscapeString(resource),
    );
    return scheduleEntry;
  }

  static ScheduleEntryType _extractEntryType(List<Element> tooltip) {
    if (tooltip.isEmpty) return ScheduleEntryType.Unknown;

    var strongTag = tooltip[0].getElementsByTagName("strong");
    if (strongTag.isEmpty) return ScheduleEntryType.Unknown;

    var typeString = strongTag[0].innerHtml;

    var type = ScheduleEntryType.Unknown;
    if (entryTypeMapping.containsKey(typeString)) {
      type = entryTypeMapping[typeString];
    }

    return type;
  }

  static Map<String, String> _parsePropertiesTable(Element infotable) {
    var map = <String, String>{};
    var labels = infotable.getElementsByClassName(LABEL_CLASS);
    var values = infotable.getElementsByClassName(VALUE_CLASS);

    for (var i = 0; i < labels.length; i++) {
      map[labels[i].innerHtml] = values[i].innerHtml;
    }
    return map;
  }

  static DateTime _parseTime(String timeString, DateTime date) {
    try {
      var time = DateFormat("HH:mm").parse(timeString.substring(0, 5));
      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    } catch (e) {
      return null;
    }
  }

  static String _extractResources(Element value) {
    var resources = value.getElementsByClassName(RESOURCE_CLASS);

    var resourcesList = <String>[];
    for (var resource in resources) {
      resourcesList.add(resource.innerHtml);
    }

    return concatStringList(resourcesList, ", ");
  }
}
