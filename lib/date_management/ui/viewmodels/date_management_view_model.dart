import 'dart:async';

import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/common/util/cancelable_mutex.dart';
import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/date_management/business/date_entry_provider.dart';
import 'package:dhbwstudentapp/date_management/model/date_database.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:dhbwstudentapp/date_management/model/date_search_parameters.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';

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

  final CancelableMutex _updateMutex = CancelableMutex();

  Timer _errorResetTimer;

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

  bool _updateFailed = false;
  bool get updateFailed => _updateFailed;

  DateSearchParameters get dateSearchParameters => DateSearchParameters(
        showPassedDates,
        showFutureDates,
        currentSelectedYear,
        currentDateDatabase?.id,
      );

  DateManagementViewModel(this._dateEntryProvider, this._preferencesProvider) {
    _buildYearsArray();
    _loadDefaultSelection();
  }

  void _buildYearsArray() {
    _years = [];

    for (var i = 2017; i < DateTime.now().year + 3; i++) {
      _years.add(i.toString());
    }
  }

  Future<void> updateDates() async {
    await _updateMutex.acquireAndCancelOther();

    try {
      _isLoading = true;
      notifyListeners("isLoading");

      await _doUpdateDates();
    } catch (_) {} finally {
      _isLoading = false;
      _updateMutex.release();
      notifyListeners("isLoading");
    }
  }

  Future<void> _doUpdateDates() async {
    var cachedDateEntries = await _readCachedDateEntries();
    _updateMutex.token.throwIfCancelled();
    _setAllDates(cachedDateEntries);

    var loadedDateEntries = await _readUpdatedDateEntries();
    _updateMutex.token.throwIfCancelled();

    if (loadedDateEntries != null) {
      _setAllDates(loadedDateEntries);
    }

    _updateFailed = loadedDateEntries == null;
    if (updateFailed) {
      _cancelErrorInFuture();
    }

    notifyListeners("updateFailed");
  }

  Future<List<DateEntry>> _readUpdatedDateEntries() async {
    try {
      var loadedDateEntries = await _dateEntryProvider.getDateEntries(
        dateSearchParameters,
        _updateMutex.token,
      );
      return loadedDateEntries;
    } on OperationCancelledException {} on ServiceRequestFailed {}

    return null;
  }

  Future<List<DateEntry>> _readCachedDateEntries() async {
    var cachedDateEntries = await _dateEntryProvider.getCachedDateEntries(
      dateSearchParameters,
    );
    return cachedDateEntries;
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

  void _loadDefaultSelection() async {
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

  void _cancelErrorInFuture() async {
    if (_errorResetTimer != null) {
      _errorResetTimer.cancel();
    }

    _errorResetTimer = Timer(
      Duration(seconds: 5),
      () {
        _updateFailed = false;
        notifyListeners("updateFailed");
      },
    );
  }
}
