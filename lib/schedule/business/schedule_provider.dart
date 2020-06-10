import 'package:dhbwstuttgart/common/util/cancellation_token.dart';
import 'package:dhbwstuttgart/schedule/business/schedule_diff_calculator.dart';
import 'package:dhbwstuttgart/schedule/data/schedule_entry_repository.dart';
import 'package:dhbwstuttgart/schedule/data/schedule_query_information_repository.dart';
import 'package:dhbwstuttgart/schedule/model/schedule.dart';
import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';
import 'package:dhbwstuttgart/schedule/model/schedule_query_information.dart';
import 'package:dhbwstuttgart/schedule/service/schedule_source.dart';
import 'package:intl/intl.dart';

typedef ScheduleUpdatedCallback = Future<void> Function(
  Schedule schedule,
  DateTime start,
  DateTime end,
);

typedef ScheduleEntryChangedCallback = Future<void> Function(
  ScheduleDiff scheduleDiff,
);

class ScheduleProvider {
  final ScheduleSource _scheduleSource;
  final ScheduleEntryRepository _scheduleEntryRepository;
  final ScheduleQueryInformationRepository _scheduleQueryInformationRepository;
  final List<ScheduleUpdatedCallback> _scheduleUpdatedCallbacks =
      <ScheduleUpdatedCallback>[];

  final List<ScheduleEntryChangedCallback> _scheduleEntryChangedCallbacks =
      <ScheduleEntryChangedCallback>[];

  ScheduleProvider(
    this._scheduleSource,
    this._scheduleEntryRepository,
    this._scheduleQueryInformationRepository,
  );

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

        await _diffToCache(start, end, updatedSchedule);
        await _scheduleEntryRepository.deleteScheduleEntriesBetween(start, end);
        await _scheduleEntryRepository.saveSchedule(updatedSchedule);
        await _scheduleQueryInformationRepository.saveScheduleQueryInformation(
          ScheduleQueryInformation(start, end, DateTime.now()),
        );
      }

      for (var c in _scheduleUpdatedCallbacks) {
        await c(updatedSchedule, start, end);
      }

      return updatedSchedule;
    } on ScheduleQueryFailedException catch (e) {
      print("Failed to fetch schedule!");
      print(e.innerException.toString());
      rethrow;
    }
  }

  Future _diffToCache(
    DateTime start,
    DateTime end,
    Schedule updatedSchedule,
  ) async {
    var oldSchedule =
        await _scheduleEntryRepository.queryScheduleBetweenDates(start, end);

    var diff =
        ScheduleDiffCalculator().calculateDiff(oldSchedule, updatedSchedule);

    var cleanedDiff = await _cleanDiffFromNewlyQueriedEntries(start, end, diff);

    if (cleanedDiff.didSomethingChange()) {
      for (var c in _scheduleEntryChangedCallbacks) {
        await c(cleanedDiff);
      }
    }
  }

  void addScheduleUpdatedCallback(ScheduleUpdatedCallback callback) {
    _scheduleUpdatedCallbacks.add(callback);
  }

  void removeScheduleUpdatedCallback(ScheduleUpdatedCallback callback) {
    if (_scheduleUpdatedCallbacks.contains(callback))
      _scheduleUpdatedCallbacks.remove(callback);
  }

  void addScheduleEntryChangedCallback(ScheduleEntryChangedCallback callback) {
    _scheduleEntryChangedCallbacks.add(callback);
  }

  void removeScheduleEntryChangedCallback(
      ScheduleEntryChangedCallback callback) {
    if (_scheduleUpdatedCallbacks.contains(callback))
      _scheduleEntryChangedCallbacks.remove(callback);
  }

  Future<ScheduleDiff> _cleanDiffFromNewlyQueriedEntries(
    DateTime start,
    DateTime end,
    ScheduleDiff diff,
  ) async {
    var queryInformation = await _scheduleQueryInformationRepository
        .getQueryInformationBetweenDates(start, end);

    var cleanedAddedEntries = <ScheduleEntry>[];

    for (var addedEntry in diff.addedEntries) {
      if (queryInformation.any((i) =>
          addedEntry.end.isAfter(i.start) &&
          addedEntry.start.isBefore(i.end))) {
        cleanedAddedEntries.add(addedEntry);
      }
    }

    return ScheduleDiff(
      addedEntries: cleanedAddedEntries,
      removedEntries: diff.removedEntries,
      updatedEntries: diff.updatedEntries,
    );
  }
}
