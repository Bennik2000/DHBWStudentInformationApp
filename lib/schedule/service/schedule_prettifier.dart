import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';

class SchedulePrettifier {
  Schedule prettifySchedule(Schedule schedule) {
    var allEntries = <ScheduleEntry>[];

    for (var entry in schedule.entries) {
      allEntries.add(prettifyScheduleEntry(entry));
    }

    return schedule.copyWith(entries: allEntries);
  }

  ScheduleEntry prettifyScheduleEntry(ScheduleEntry entry) {
    entry = _removeCourseFromTitle(entry);
    entry = _removeOnlinePrefix(entry);

    return entry;
  }

  ScheduleEntry _removeOnlinePrefix(ScheduleEntry entry) {
    // Sometimes the entry type is not set correctly. When the title of a class
    // begins with "Online - " it implies that it is online
    // In this case remove the online prefix and set the type correctly
    if (!(entry.title.startsWith("Online - ") &&
        entry.type == ScheduleEntryType.Class)) {
      return entry;
    }

    var title = entry.title.substring("Online - ".length);
    var type = ScheduleEntryType.Online;

    return entry.copyWith(title: title, type: type);
  }

  ScheduleEntry _removeCourseFromTitle(ScheduleEntry entry) {
    var title = entry.title;
    var details = entry.details;

    var titleRegex =
        RegExp("[A-Z]{3,}-?[A-Z]+[0-9]*[A-Z]*[0-9]*[\/]?[A-Z]*[0-9]*[ ]*-?");
    var match = titleRegex.firstMatch(entry.title);

    if (match != null && match.start == 0) {
      details = title.substring(0, match.end) + " - $details";
      title = title.substring(match.end).trim();
    } else {
      var first = title.split(" ").first;

      // Prettify titles: T3MB9025 Fluidmechanik -> Fluidmechanik

      // The title can not be prettified, if the first word is not only uppercase
      // or less than 2 charcters long
      if (!(first == first.toUpperCase() && first.length >= 3)) return entry;

      var numberCount = first.split(new RegExp("[0-9]")).length;

      // If there are less thant two numbers in the title, do not prettify it
      if (numberCount < 2) return entry;

      details = title.substring(0, first.length) + " . $details";
      title = title.substring(first.length).trim();
    }

    return entry.copyWith(title: title, details: details);
  }
}
