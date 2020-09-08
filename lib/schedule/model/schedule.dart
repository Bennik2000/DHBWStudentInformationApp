import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';

class Schedule {
  final List<ScheduleEntry> entries;

  Schedule() : entries = <ScheduleEntry>[];
  Schedule.fromList(this.entries);

  void addEntry(ScheduleEntry entry) {
    entries.add(entry);
  }

  void merge(Schedule schedule) {
    entries.addAll(schedule
        .entries); // TODO: Return new schedule instead of adding it to the list
  }

  Schedule trim(DateTime startDate, DateTime endDate) {
    var newList = <ScheduleEntry>[];

    for (var entry in entries) {
      if (startDate.isBefore(entry.end) && endDate.isAfter(entry.start)) {
        newList.add(entry);
      }
    }

    return Schedule.fromList(newList);
  }

  DateTime getStartDate() {
    if (entries.isEmpty) return null;

    var date = entries?.reduce((ScheduleEntry a, ScheduleEntry b) {
      return a.start.isBefore(b.start) ? a : b;
    })?.start;

    return date;
  }

  DateTime getEndDate() {
    if (entries.isEmpty) return null;

    var date = entries?.reduce((ScheduleEntry a, ScheduleEntry b) {
      return a.end.isAfter(b.end) ? a : b;
    })?.end;

    return date;
  }

  DateTime getStartTime() {
    DateTime earliestTime;

    for (var entry in entries) {
      var entryTime = DateTime(
        0,
        1,
        1,
        entry.start.hour,
        entry.start.minute,
        entry.start.second,
        entry.start.millisecond,
        entry.start.microsecond,
      );

      if (earliestTime == null || entryTime.isBefore(earliestTime)) {
        earliestTime = entryTime;
      }
    }

    return earliestTime;
  }

  DateTime getEndTime() {
    DateTime latestTime;

    for (var entry in entries) {
      var entryTime = DateTime(
        0,
        1,
        1,
        entry.end.hour,
        entry.end.minute,
        entry.end.second,
        entry.end.millisecond,
        entry.end.microsecond,
      );

      if (latestTime == null || entryTime.isAfter(latestTime)) {
        latestTime = entryTime;
      }
    }

    return latestTime;
  }
}
