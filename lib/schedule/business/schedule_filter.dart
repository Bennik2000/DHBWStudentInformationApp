import 'package:dhbwstudentapp/schedule/data/schedule_filter_repository.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';

class ScheduleFilter {
  final ScheduleFilterRepository _scheduleFilterRepository;

  ScheduleFilter(this._scheduleFilterRepository);

  Future<Schedule> filter(Schedule original) async {
    final allHiddenNames =
        await _scheduleFilterRepository.queryAllHiddenNames();

    final allEntries = <ScheduleEntry>[];

    for (final entry in original.entries) {
      if (allHiddenNames.contains(entry.title)) {
        continue;
      }

      allEntries.add(entry);
    }

    return original.copyWith(entries: allEntries);
  }
}
