import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_diff_calculator.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:dhbwstudentapp/schedule/data/schedule_entry_repository.dart';
import 'package:dhbwstudentapp/schedule/data/schedule_query_information_repository.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_information.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_result.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_prettifier.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';
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
  final PreferencesProvider _preferencesProvider;
  final ScheduleSourceProvider _scheduleSource;
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
    this._preferencesProvider,
  );

  Future<Schedule> getCachedSchedule(DateTime start, DateTime end) async {
    var cachedSchedule =
        await _scheduleEntryRepository.queryScheduleBetweenDates(start, end);

    print(
        "Read chached schedule with ${cachedSchedule.entries.length.toString()} entries");

    return cachedSchedule;
  }

  Future<ScheduleQueryResult> getUpdatedSchedule(
    DateTime start,
    DateTime end,
    CancellationToken cancellationToken,
  ) async {
    print(
        "Fetching schedule for ${DateFormat.yMd().format(start)} - ${DateFormat.yMd().format(end)}");

    try {
      var updatedSchedule = await _scheduleSource.currentScheduleSource
          .querySchedule(start, end, cancellationToken);

      var schedule = updatedSchedule.schedule;

      if (schedule == null) {
        print("No schedule returned!");
      } else {
        if (await _preferencesProvider.getPrettifySchedule()) {
          schedule = SchedulePrettifier().prettifySchedule(schedule);
        }

        print(
            "Schedule returned with ${schedule.entries.length.toString()} entries");

        await _diffToCache(start, end, schedule);
        await _scheduleEntryRepository.deleteScheduleEntriesBetween(start, end);
        await _scheduleEntryRepository.saveSchedule(schedule);
        await _scheduleQueryInformationRepository.saveScheduleQueryInformation(
          ScheduleQueryInformation(start, end, DateTime.now()),
        );
      }

      for (var c in _scheduleUpdatedCallbacks) {
        await c(schedule, start, end);
      }

      updatedSchedule = ScheduleQueryResult(schedule, updatedSchedule.errors);

      return updatedSchedule;
    } on ScheduleQueryFailedException catch (e, trace) {
      print("Failed to fetch schedule!");
      print(e.innerException.toString());
      print(trace);
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
