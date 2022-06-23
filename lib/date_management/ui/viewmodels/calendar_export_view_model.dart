import 'package:device_calendar/device_calendar.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/date_management/data/calendar_access.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';

typedef OnPermissionDenied = Function();

class CalendarExportViewModel extends BaseViewModel {
  final CalendarAccess calendarAccess;
  final PreferencesProvider preferencesProvider;
  final List<DateEntry> _entriesToExport;

  OnPermissionDenied _onPermissionDenied;

  List<Calendar> _calendars;
  List<Calendar> get calendars => _calendars ?? [];

  Calendar _selectedCalendar;
  Calendar get selectedCalendar => _selectedCalendar;

  bool get canExport => _selectedCalendar != null;

  bool _isExporting = false;
  bool get isExporting => _isExporting;

  CalendarExportViewModel(this._entriesToExport, this.calendarAccess, this.preferencesProvider) {
    loadCalendars();
  }

  Future<void> loadCalendars() async {
    var access = await calendarAccess.requestCalendarPermission();

    if (access == CalendarPermission.PermissionDenied) {
      _onPermissionDenied?.call();
      return;
    }

    _calendars = await calendarAccess.queryWriteableCalendars();

    notifyListeners("_calendars");
  }

  void loadSelectedCalendar() async{
    _selectedCalendar = await preferencesProvider.getSelectedCalendar();
    notifyListeners("selectedCalendar");
  }

  void resetSelectedCalendar() async{
    await preferencesProvider.setSelectedCalendar(null);
    this.loadCalendars();
  }

  void toggleSelection(Calendar calendar) {
    if (_selectedCalendar == calendar) {
      _selectedCalendar = null;
    } else {
      _selectedCalendar = calendar;
    }

    notifyListeners("selectedCalendar");
    notifyListeners("canExport");
  }

  Future<void> export() async {
    if (selectedCalendar != null) {
      _isExporting = true;
      notifyListeners("isExporting");

      await calendarAccess.addOrUpdateDates(
        _entriesToExport,
        _selectedCalendar,
      );

      _isExporting = false;
      notifyListeners("isExporting");
    }
  }

  void setOnPermissionDeniedCallback(OnPermissionDenied function) {
    _onPermissionDenied = function;
  }
}
