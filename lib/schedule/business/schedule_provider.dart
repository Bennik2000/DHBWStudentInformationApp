import 'package:dhbwstuttgart/common/util/cancellation_token.dart';
import 'package:dhbwstuttgart/schedule/data/schedule_entry_repository.dart';
import 'package:dhbwstuttgart/schedule/model/schedule.dart';
import 'package:dhbwstuttgart/schedule/service/schedule_source.dart';
import 'package:intl/intl.dart';

class ScheduleProvider {
  final ScheduleSource _scheduleSource;
  final ScheduleEntryRepository _scheduleEntryRepository;

  ScheduleProvider(this._scheduleSource, this._scheduleEntryRepository);

  Future<Schedule> getCachedSchedule(DateTime start, DateTime end) async {
    var cachedSchedule =
        await _scheduleEntryRepository.queryScheduleBetweenDates(start, end);

    print("Read chached schedule with " +
        cachedSchedule.entries.length.toString() +
        " entries");

    return cachedSchedule;
  }

  Future<Schedule> getUpdatedSchedule(
    DateTime start,
    DateTime end,
    CancellationToken cancellationToken,
  ) async {
    print(
        "Fetching schedule for ${DateFormat.yMd().format(start)} - ${DateFormat.yMd().format(end)}");

    try {
      var updatedSchedule =
          await _scheduleSource.querySchedule(start, end, cancellationToken);

      if (updatedSchedule == null) {
        print("No schedule returned!");
      } else {
        print(
            "Schedule returned with ${updatedSchedule.entries.length.toString()} entries");

        // TODO: Calculate diff

        await _scheduleEntryRepository.deleteScheduleEntriesBetween(start, end);
        await _scheduleEntryRepository.saveSchedule(updatedSchedule);
      }

      return updatedSchedule;
    } on ScheduleQueryFailedException catch (e) {
      print("Failed to fetch schedule!");
      print(e.innerException.toString());
      rethrow;
    }
  }
}
