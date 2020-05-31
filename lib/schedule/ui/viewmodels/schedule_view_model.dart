import 'package:dhbwstuttgart/common/data/database_access.dart';
import 'package:dhbwstuttgart/common/ui/base_view_model.dart';
import 'package:dhbwstuttgart/common/util/cancellation_token.dart';
import 'package:dhbwstuttgart/schedule/business/schedule_provider.dart';
import 'package:dhbwstuttgart/schedule/data/schedule_entry_repository.dart';
import 'package:dhbwstuttgart/schedule/model/schedule.dart';
import 'package:dhbwstuttgart/schedule/service/rapla/rapla_schedule_source.dart';
import 'package:intl/intl.dart';

class WeeklyScheduleViewModel extends BaseViewModel {
  static const Duration weekDuration = Duration(days: 7);

  ScheduleProvider _scheduleProvider;

  DateTime currentDateStart;
  DateTime currentDateEnd;

  bool isUpdating = false;
  bool isFetching = false;
  Schedule weekSchedule;

  CancellationToken _updateScheduleCancellationToken;

  WeeklyScheduleViewModel() {
    _scheduleProvider = new ScheduleProvider(
      new RaplaScheduleSource(
          "https://rapla.dhbw-stuttgart.de/rapla?key=txB1FOi5xd1wUJBWuX8lJhGDUgtMSFmnKLgAG_NVMhCn4AzVqTBQM-yMcTKkIDCa"),
      new ScheduleEntryRepository(new DatabaseAccess()),
    );

    goToToday();
  }

  Future nextWeek() async {
    currentDateStart = currentDateStart.add(weekDuration);
    currentDateEnd = currentDateEnd.add(weekDuration);

    await updateSchedule();
  }

  Future previousWeek() async {
    currentDateStart = currentDateStart.subtract(weekDuration);
    currentDateEnd = currentDateEnd.subtract(weekDuration);

    await updateSchedule();
  }

  Future goToToday() async {
    var now = DateTime.now();
    currentDateStart = DateTime(now.year, now.month, now.day);
    currentDateStart =
        currentDateStart.subtract(Duration(days: currentDateStart.weekday - 1));
    currentDateEnd = currentDateStart.add(weekDuration);

    await updateSchedule();
  }

  Future updateSchedule() async {
    print(DateFormat.yMd().format(currentDateStart));

    if (_updateScheduleCancellationToken != null) {
      _updateScheduleCancellationToken.cancel();
      print("Initiated cancel!");
    }

    _updateScheduleCancellationToken = new CancellationToken();

    isUpdating = true;
    notifyListeners("isUpdating");
    print("Refreshing schedule...");

    await _updateScheduleFromCache();

    if (_updateScheduleCancellationToken.isCancelled()) return;

    await _updateScheduleFromService();

    isUpdating = false;
    notifyListeners("isUpdating");
    print("Refreshing done");
  }

  Future _updateScheduleFromCache() async {
    weekSchedule = await _scheduleProvider.getCachedSchedule(
      currentDateStart,
      currentDateEnd,
    );
    notifyListeners("weekSchedule");
  }

  Future _updateScheduleFromService() async {
    var updatedSchedule = await _scheduleProvider.getUpdatedSchedule(
      currentDateStart,
      currentDateEnd,
      _updateScheduleCancellationToken,
    );

    if (!_updateScheduleCancellationToken.isCancelled()) {
      weekSchedule = updatedSchedule;
      print(
          "_scheduleProvider.getUpdatedSchedule was not cancelled and returned an object: " +
              ((updatedSchedule != null) ? "true" : "false"));
    }

    notifyListeners("weekSchedule");
  }
}
