import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';

class SchedulePrettifier {
  SchedulePrettifier();

  final RegExp onlinePrefixRegExp =
      RegExp(r'\(?online\)?([ -]*)', caseSensitive: false);
  final RegExp onlineSuffixRegExp =
      RegExp(r'([ -]*)\(?online\)?', caseSensitive: false);

  Schedule prettifySchedule(Schedule schedule) {
    final allEntries = <ScheduleEntry>[];

    for (final entry in schedule.entries) {
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

    var newTitle = entry.title;
    newTitle = newTitle.replaceFirst(onlinePrefixRegExp, "");
    newTitle = newTitle.replaceFirst(onlineSuffixRegExp, "");

    if (newTitle == entry.title) {
      return entry;
    }

    const type = ScheduleEntryType.Online;

    return entry.copyWith(title: newTitle, type: type);
  }

  ScheduleEntry _removeCourseFromTitle(ScheduleEntry entry) {
    var title = entry.title;
    var details = entry.details;

    final titleRegex =
        RegExp("[A-Z]{3,}-?[A-Z]+[0-9]*[A-Z]*[0-9]*[/]?[A-Z]*[0-9]*[ ]*-?");
    final match = titleRegex.firstMatch(entry.title);

    if (match != null && match.start == 0) {
      details = "${title.substring(0, match.end)} - $details";
      title = title.substring(match.end).trim();
    } else {
      final first = title.split(" ").first;

      // Prettify titles: T3MB9025 Fluidmechanik -> Fluidmechanik

      // The title can not be prettified, if the first word is not only uppercase
      // or less than 2 charcters long
      if (!(first == first.toUpperCase() && first.length >= 3)) return entry;

      final numberCount = first.split(RegExp("[0-9]")).length;

      // If there are less thant two numbers in the title, do not prettify it
      if (numberCount < 2) return entry;

      details = "${title.substring(0, first.length)} - $details";
      title = title.substring(first.length).trim();
    }

    return entry.copyWith(title: title, details: details);
  }
}
