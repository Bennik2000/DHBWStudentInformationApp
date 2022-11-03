import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';

part 'schedule.g.dart';

@CopyWith()
class Schedule {
  final List<ScheduleEntry> entries;
  final List<String> urls;

  const Schedule({
    this.entries = const <ScheduleEntry>[],
    this.urls = const <String>[],
  });

  void merge(Schedule schedule) {
    // TODO: Return new schedule instead of adding it to the list
    urls.addAll(schedule.urls);

    for (final newEntry in schedule.entries) {
      if (entries.any((element) => element == newEntry)) {
        continue;
      }

      entries.add(newEntry);
    }
  }

  // TODO: [Leptopoda] improve nullability
  Schedule trim(DateTime? startDate, DateTime? endDate) {
    final newList = <ScheduleEntry>[];

    for (final entry in entries) {
      if (startDate!.isBefore(entry.end) && endDate!.isAfter(entry.start)) {
        newList.add(entry);
      }
    }

    final schedule = Schedule(entries: newList, urls: urls);

    return schedule;
  }

  DateTime? getStartDate() {
    if (entries.isEmpty) return null;

    final date = entries.reduce((ScheduleEntry? a, ScheduleEntry? b) {
      return a!.start.isBefore(b!.start) ? a : b;
    }).start;

    return date;
  }

  DateTime? getEndDate() {
    if (entries.isEmpty) return null;

    final date = entries.reduce((ScheduleEntry? a, ScheduleEntry? b) {
      return a!.end.isAfter(b!.end) ? a : b;
    }).end;

    return date;
  }

  DateTime? getStartTime() {
    DateTime? earliestTime;

    for (final entry in entries) {
      final entryTime = DateTime(
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

  DateTime? getEndTime() {
    DateTime? latestTime;

    for (final entry in entries) {
      final entryTime = DateTime(
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
