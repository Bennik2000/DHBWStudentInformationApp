import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';

class Schedule {
  final List<ScheduleEntry> entries;

  Schedule() : entries = List<ScheduleEntry>();
  Schedule.fromList(this.entries);

  void addEntry(ScheduleEntry entry) {
    entries.add(entry);
  }

  void merge(Schedule schedule) {
    entries.addAll(schedule.entries);
  }
}
