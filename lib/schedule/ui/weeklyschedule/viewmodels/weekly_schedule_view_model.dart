import 'dart:async';

import 'package:dhbwstuttgart/common/ui/base_view_model.dart';
import 'package:dhbwstuttgart/common/util/cancellation_token.dart';
import 'package:dhbwstuttgart/common/util/date_utils.dart';
import 'package:dhbwstuttgart/schedule/business/schedule_provider.dart';
import 'package:dhbwstuttgart/schedule/model/schedule.dart';
import 'package:dhbwstuttgart/schedule/service/schedule_source.dart';
import 'package:intl/intl.dart';

class WeeklyScheduleViewModel extends BaseViewModel {
  static const Duration weekDuration = Duration(days: 7);

  ScheduleProvider scheduleProvider;

  DateTime currentDateStart;
  DateTime currentDateEnd;

  DateTime clippedDateStart;
  DateTime clippedDateEnd;

  bool updateFailed = false;

  bool isUpdating = false;
  Schedule weekSchedule;

  Timer _errorResetTimer = null;

  CancellationToken _updateScheduleCancellationToken;

  WeeklyScheduleViewModel(this.scheduleProvider) {
    goToToday();
  }

  Future setSchedule(Schedule schedule) async {
    weekSchedule = schedule;

    clippedDateStart = weekSchedule?.getStartDate();
    clippedDateEnd = weekSchedule?.getEndDate();

    notifyListeners("weekSchedule");
  }

  Future nextWeek() async {
    currentDateStart = toNextWeek(currentDateStart);
    currentDateEnd = toNextWeek(currentDateEnd);

    await updateSchedule();
  }

  Future previousWeek() async {
    currentDateStart = toPreviousWeek(currentDateStart);
    currentDateEnd = toPreviousWeek(currentDateEnd);

    if (currentDateStart.hour == 23)
      print("Is hour 23: " + DateFormat.yMd().format(currentDateStart));

    await updateSchedule();
  }

  Future goToToday() async {
    var now = DateTime.now();
    currentDateStart = toStartOfDay(toMonday(now));
    currentDateEnd = currentDateStart.add(Duration(days: 5));

    await updateSchedule();
  }

  Future updateSchedule() async {
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
    setSchedule(
      await scheduleProvider.getCachedSchedule(
        currentDateStart,
        currentDateEnd,
      ),
    );
  }

  Future _updateScheduleFromService() async {
    try {
      var updatedSchedule = await scheduleProvider.getUpdatedSchedule(
        currentDateStart,
        currentDateEnd,
        _updateScheduleCancellationToken,
      );

      updateFailed = false;
      notifyListeners("updateFailed");

      setSchedule(updatedSchedule);
    } on OperationCancelledException catch (e) {} on ScheduleQueryFailedException catch (e) {
      updateFailed = true;
      notifyListeners("updateFailed");
      cancelErrorInFuture();
    }
  }

  void cancelErrorInFuture() async {
    if (_errorResetTimer != null) {
      _errorResetTimer.cancel();
    }

    _errorResetTimer = Timer(
      Duration(seconds: 5),
      () {
        updateFailed = false;
        notifyListeners("updateFailed");
      },
    );
  }
}
