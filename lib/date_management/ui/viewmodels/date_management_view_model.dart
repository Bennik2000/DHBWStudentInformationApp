import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/common/util/cancelable_mutex.dart';
import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/date_management/business/date_entry_provider.dart';
import 'package:dhbwstudentapp/date_management/model/date_database.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:dhbwstudentapp/date_management/model/date_search_parameters.dart';

class DateManagementViewModel extends BaseViewModel {
  final DateEntryProvider _dateEntryProvider;
  final PreferencesProvider _preferencesProvider;

  final List<DateDatabase> _allDateDatabases = [
    DateDatabase("Termine_BWL_Bank", "Termine_BWL_Bank"),
    DateDatabase("Termine_BWL_Immo", "Termine_BWL_Immo"),
    DateDatabase("Termine_DLM_Consult", "Termine_DLM_Consult"),
    DateDatabase("Termine_DLM_Logistik", "Termine_DLM_Logistik"),
    DateDatabase("Termine_Horb_INF", "Termine_Horb_INF"),
    DateDatabase("Termine_Horb_MB", "Termine_Horb_MB"),
    DateDatabase("Termine_Horbtest", "Termine_Horbtest"),
    DateDatabase("Termine_IB", "Termine_IB"),
    DateDatabase("Termine_Informatik", "Termine_Informatik"),
    DateDatabase("Termine_MUK", "Termine_MUK"),
    DateDatabase("Termine_SO_GuO", "Termine_SO_GuO"),
    DateDatabase("Termine_WIW", "Termine_WIW"),
  ];
  List<DateDatabase> get allDateDatabases => _allDateDatabases;

  final CancelableMutex _updateMutex = new CancelableMutex();

  List<String> _years;
  List<String> get years => _years;

  String _currentSelectedYear;
  String get currentSelectedYear => _currentSelectedYear;

  List<DateEntry> _allDates;
  List<DateEntry> get allDates => _allDates;

  bool _showPassedDates = false;
  bool get showPassedDates => _showPassedDates;

  bool _showFutureDates = true;
  bool get showFutureDates => _showFutureDates;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DateDatabase _currentDateDatabase;
  DateDatabase get currentDateDatabase => _currentDateDatabase;

  int _dateEntriesKeyIndex = 0;
  int get dateEntriesKeyIndex => _dateEntriesKeyIndex;

  DateSearchParameters get dateSearchParameters => DateSearchParameters(
        showPassedDates,
        showFutureDates,
        currentSelectedYear,
        currentDateDatabase?.id,
      );

  DateManagementViewModel(this._dateEntryProvider, this._preferencesProvider) {
    _buildYearsArray();

    _loadLastSelectedParameters();
  }

  void _buildYearsArray() {
    _years = [];

    for (var i = 2017; i < DateTime.now().year + 3; i++) {
      _years.add(i.toString());
    }
  }

  Future<void> updateDates() async {
    _updateMutex.acquireAndCancelOther();

    _isLoading = true;
    notifyListeners("isLoading");

    try {
      var loadedDateEntries = _dateEntryProvider.getDateEntries(
        dateSearchParameters,
        _updateMutex.token,
      );

      var cachedDateEntries = _dateEntryProvider.getCachedDateEntries(
        dateSearchParameters,
      );

      _setAllDates(await cachedDateEntries);
      _setAllDates(await loadedDateEntries);
    } on OperationCancelledException catch (_) {} finally {
      _isLoading = false;
      notifyListeners("isLoading");

      _updateMutex.release();
    }
  }

  void _setAllDates(List<DateEntry> dateEntries) {
    _allDates = dateEntries;
    _dateEntriesKeyIndex++;

    notifyListeners("allDates");
  }

  void setShowPassedDates(bool value) {
    _showPassedDates = value;
    notifyListeners("showPassedDates");
  }

  void setShowFutureDates(bool value) {
    _showFutureDates = value;
    notifyListeners("showFutureDates");
  }

  void setCurrentDateDatabase(DateDatabase database) {
    _currentDateDatabase = database;
    notifyListeners("currentDateDatabase");

    _preferencesProvider.setLastViewedDateEntryDatabase(database?.id);
  }

  void setCurrentSelectedYear(String year) {
    _currentSelectedYear = year;
    notifyListeners("currentSelectedYear");

    _preferencesProvider.setLastViewedDateEntryYear(year);
  }

  void _loadLastSelectedParameters() async {
    var database = await _preferencesProvider.getLastViewedDateEntryDatabase();

    bool didSetDatabase = false;
    for (var db in allDateDatabases) {
      if (db.id == database) {
        setCurrentDateDatabase(db);
        didSetDatabase = true;
      }
    }
    if (!didSetDatabase) {
      setCurrentDateDatabase(allDateDatabases[0]);
    }

    var year = await _preferencesProvider.getLastViewedDateEntryYear();
    if (year != null) {
      setCurrentSelectedYear(year);
    } else {
      setCurrentSelectedYear(years[0]);
    }

    await updateDates();
  }
}
