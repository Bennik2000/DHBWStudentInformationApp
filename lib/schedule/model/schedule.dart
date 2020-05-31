import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';

class Schedule {
  final List<ScheduleEntry> entries;

  Schedule() : entries = List<ScheduleEntry>();
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
    if (entries.length == 0) return null;

    var date = entries?.reduce((ScheduleEntry a, ScheduleEntry b) {
      return a.start.isBefore(b.start) ? a : b;
    })?.start;

    return date;
  }

  DateTime getEndDate() {
    if (entries.length == 0) return null;

    var date = entries?.reduce((ScheduleEntry a, ScheduleEntry b) {
      return a.end.isAfter(b.end) ? a : b;
    })?.end;

    return date;
  }
}
