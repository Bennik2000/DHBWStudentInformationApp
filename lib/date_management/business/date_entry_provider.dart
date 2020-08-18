import 'package:dhbwstudentapp/date_management/data/date_entry_repository.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:dhbwstudentapp/date_management/service/date_management_service.dart';

class DateEntryProvider {
  final DateManagementService _dateEntryService;
  final DateEntryRepository _dateEntryRepository;

  DateEntryProvider(this._dateEntryService, this._dateEntryRepository);

  Future<List<DateEntry>> getCachedDateEntries() async {
    return await _dateEntryRepository.queryAllDateEntries();
  }

  Future<List<DateEntry>> getDateEntries() async {
    var updatedEntries = await _dateEntryService.queryAllDates("");
    await _dateEntryRepository.deleteAllDateEntries();
    await _dateEntryRepository.saveDateEntries(updatedEntries);

    return updatedEntries;
  }
}
