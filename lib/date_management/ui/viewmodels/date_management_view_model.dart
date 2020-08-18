import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/date_management/business/date_entry_provider.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';

class DateManagementViewModel extends BaseViewModel {
  final DateEntryProvider _dateEntryProvider;

  List<DateEntry> _allDates;
  List<DateEntry> get allDates => _allDates;

  DateManagementViewModel(this._dateEntryProvider) {
    loadDates();
  }

  Future<void> loadDates() async {
    var loadedDateEntries = _dateEntryProvider.getDateEntries();
    var cachedDateEntries = _dateEntryProvider.getCachedDateEntries();

    _setAllDates(await cachedDateEntries);
    _setAllDates(await loadedDateEntries);
  }

  void _setAllDates(List<DateEntry> dateEntries) {
    _allDates = dateEntries;
    notifyListeners("allDates");
  }
}
