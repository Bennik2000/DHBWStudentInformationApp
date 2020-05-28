import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';
import 'package:dhbwstuttgart/schedule/ui/widgets/schedule_widget.dart';

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

  Schedule trim(DateTime startDate, DateTime endDate) {
    var newList = <ScheduleEntry>[];

    for (var entry in entries) {
      if (startDate.isBefore(entry.end) && endDate.isAfter(entry.start)) {
        newList.add(entry);
      }
    }

    return Schedule.fromList(newList);
  }
}
