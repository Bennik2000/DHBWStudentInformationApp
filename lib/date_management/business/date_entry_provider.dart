import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/date_management/data/date_entry_repository.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:dhbwstudentapp/date_management/model/date_search_parameters.dart';
import 'package:dhbwstudentapp/date_management/service/date_management_service.dart';

class DateEntryProvider {
  final DateManagementService _dateEntryService;
  final DateEntryRepository _dateEntryRepository;

  DateEntryProvider(this._dateEntryService, this._dateEntryRepository);

  Future<List<DateEntry>> getCachedDateEntries(
    DateSearchParameters parameters,
  ) async {
    List<DateEntry> cachedEntries = <DateEntry>[];

    if (parameters.includeFuture! && parameters.includePast!) {
      cachedEntries = await _dateEntryRepository.queryAllDateEntries(
        parameters.databaseName,
        parameters.year,
      );
    } else {
      var now = DateTime.now();
      if (parameters.includeFuture!) {
        var datesAfter = await _dateEntryRepository.queryDateEntriesAfter(
          parameters.databaseName,
          parameters.year,
          now,
        );
        cachedEntries.addAll(datesAfter);
      }

      if (parameters.includePast!) {
        var datesBefore = await _dateEntryRepository.queryDateEntriesBefore(
          parameters.databaseName,
          parameters.year,
          now,
        );
        cachedEntries.addAll(datesBefore);
      }
    }

    cachedEntries.sort(
      (DateEntry a1, DateEntry a2) => a1.start.compareTo(a2.start),
    );

    print("Read cached ${cachedEntries.length} date entries");

    return cachedEntries;
  }

  Future<List<DateEntry>> getDateEntries(
    DateSearchParameters parameters,
    CancellationToken? cancellationToken,
  ) async {
    var updatedEntries = await _dateEntryService.queryAllDates(
      parameters,
      cancellationToken,
    );

    await _dateEntryRepository.deleteAllDateEntries(
      parameters.databaseName,
      parameters.year,
    );
    await _dateEntryRepository.saveDateEntries(updatedEntries);

    var filteredDates = _filterDates(updatedEntries, parameters);

    print("Read ${filteredDates.length} date entries");

    return filteredDates;
  }

  List<DateEntry> _filterDates(
      List<DateEntry> updatedEntries, DateSearchParameters parameters,) {
    var filteredDateEntries = <DateEntry>[];

    var now = DateTime.now();

    for (var dateEntry in updatedEntries) {
      if (dateEntry.databaseName != parameters.databaseName) {
        continue;
      }

      if (dateEntry.start.isBefore(now) && !parameters.includePast!) {
        continue;
      }

      if (dateEntry.end.isAfter(now) && !parameters.includeFuture!) {
        continue;
      }

      filteredDateEntries.add(dateEntry);
    }

    return filteredDateEntries;
  }
}
