import 'dart:async';

import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/common/util/cancelable_mutex.dart';
import 'package:dhbwstudentapp/date_management/business/date_entry_provider.dart';
import 'package:dhbwstudentapp/date_management/model/date_database.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:dhbwstudentapp/date_management/model/date_search_parameters.dart';

class DateManagementViewModel extends BaseViewModel {
  final DateEntryProvider _dateEntryProvider;
  final PreferencesProvider _preferencesProvider;

  final List<DateDatabase> _allDateDatabases = [
    DateDatabase("BWL-Bank", "Termine_BWL_Bank"),
    DateDatabase("Immobilienwirtschaft", "Termine_BWL_Immo"),
    DateDatabase(
      "Dienstleistungsmanagement Consulting & Sales",
      "Termine_DLM_Consult",
    ),
    DateDatabase("Dienstleistungsmanagement Logistik", "Termine_DLM_Logistik"),
    DateDatabase("Campus Horb Informatik", "Termine_Horb_INF"),
    DateDatabase("Campus Horb Maschinenbau", "Termine_Horb_MB"),
    DateDatabase("International Business", "Termine_IB"),
    DateDatabase("Informatik", "Termine_Informatik"),
    DateDatabase("MUK (DLM - C&S, LogM, MUK)", "Termine_MUK"),
    DateDatabase(
      "SO_GuO (Abweichungen und Ergänzungen zum Vorlesungsplan)",
      "Termine_SO_GuO",
    ),
    DateDatabase("Wirtschaftsingenieurwesen", "Termine_WIW"),
  ];
  List<DateDatabase> get allDateDatabases => _allDateDatabases;

  final CancelableMutex _updateMutex = CancelableMutex();

  Timer? _errorResetTimer;

  final List<String> _years = [];
  List<String> get years => _years;

  String? _currentSelectedYear;
  String? get currentSelectedYear => _currentSelectedYear;

  List<DateEntry>? _allDates;
  List<DateEntry>? get allDates => _allDates;

  bool _showPassedDates = false;
  bool get showPassedDates => _showPassedDates;

  bool _showFutureDates = true;
  bool get showFutureDates => _showFutureDates;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DateDatabase? _currentDateDatabase;
  DateDatabase? get currentDateDatabase => _currentDateDatabase;

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
    } catch (_) {
    } finally {
      _isLoading = false;
      _updateMutex.release();
      notifyListeners("isLoading");
    }
  }

  Future<void> _doUpdateDates() async {
    final cachedDateEntries = await _readCachedDateEntries();
    _updateMutex.token?.throwIfCancelled();
    _setAllDates(cachedDateEntries);

    final loadedDateEntries = await _readUpdatedDateEntries();
    _updateMutex.token?.throwIfCancelled();

    if (loadedDateEntries != null) {
      _setAllDates(loadedDateEntries);
    }

    _updateFailed = loadedDateEntries == null;
    if (updateFailed) {
      _cancelErrorInFuture();
    }

    notifyListeners("updateFailed");
  }

  Future<List<DateEntry>?> _readUpdatedDateEntries() async {
    try {
      final loadedDateEntries = await _dateEntryProvider.getDateEntries(
        dateSearchParameters,
        _updateMutex.token,
      );
      return loadedDateEntries;
    } catch (_) {
      return null;
    }
  }

  Future<List<DateEntry>> _readCachedDateEntries() async {
    return _dateEntryProvider.getCachedDateEntries(
      dateSearchParameters,
    );
  }

  void _setAllDates(List<DateEntry> dateEntries) {
    _allDates = dateEntries;
    _dateEntriesKeyIndex++;

    notifyListeners("allDates");
  }

  set showPassedDates(bool? value) {
    if (value == null) return;

    _showPassedDates = value;
    notifyListeners("showPassedDates");
  }

  set showFutureDates(bool? value) {
    if (value == null) return;

    _showFutureDates = value;
    notifyListeners("showFutureDates");
  }

  set currentDateDatabase(DateDatabase? database) {
    _currentDateDatabase = database;
    notifyListeners("currentDateDatabase");

    _preferencesProvider.setLastViewedDateEntryDatabase(database?.id);
  }

  set currentSelectedYear(String? year) {
    if (year == null) return;

    _currentSelectedYear = year;
    notifyListeners("currentSelectedYear");

    _preferencesProvider.setLastViewedDateEntryYear(year);
  }

  Future<void> _loadDefaultSelection() async {
    final database =
        await _preferencesProvider.getLastViewedDateEntryDatabase();

    bool didSetDatabase = false;
    for (final db in allDateDatabases) {
      if (db.id == database) {
        currentDateDatabase = db;
        didSetDatabase = true;
      }
    }

    if (!didSetDatabase) {
      currentDateDatabase = allDateDatabases[0];
    }

    final year = await _preferencesProvider.getLastViewedDateEntryYear();
    currentSelectedYear = year ?? years[0];

    await updateDates();
  }

  Future<void> _cancelErrorInFuture() async {
    _errorResetTimer?.cancel();

    _errorResetTimer = Timer(
      const Duration(seconds: 5),
      () {
        _updateFailed = false;
        notifyListeners("updateFailed");
      },
    );
  }
}
