import 'dart:async';
import 'dart:math';

import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/common/util/date_utils.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_provider.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';

class WeeklyScheduleViewModel extends BaseViewModel {
  static const Duration weekDuration = Duration(days: 7);

  ScheduleProvider scheduleProvider;

  DateTime currentDateStart;
  DateTime currentDateEnd;

  DateTime clippedDateStart;
  DateTime clippedDateEnd;

  bool didUpdateScheduleIntoFuture = true;

  int displayStartHour = 7;
  int displayEndHour = 17;

  bool updateFailed = false;

  bool isUpdating = false;
  Schedule weekSchedule;

  DateTime now;

  Timer _errorResetTimer;
  Timer _updateNowTimer;

  CancellationToken _updateScheduleCancellationToken;

  WeeklyScheduleViewModel(this.scheduleProvider) {
    now = DateTime.now();
    _startUpdateNowTimer();
    goToToday();
  }

  void _setSchedule(Schedule schedule) {
    weekSchedule = schedule;

    if (weekSchedule != null) {
      var scheduleStart = weekSchedule.getStartDate();
      clippedDateStart = toDayOfWeek(scheduleStart, DateTime.monday);

      if (scheduleStart?.isBefore(clippedDateStart) ?? false)
        clippedDateStart = scheduleStart;

      var scheduleEnd = weekSchedule.getEndDate();
      clippedDateEnd = toDayOfWeek(scheduleEnd, DateTime.friday);

      if (scheduleEnd?.isAfter(clippedDateEnd) ?? false)
        clippedDateEnd = scheduleEnd;

      displayStartHour = weekSchedule?.getStartTime()?.hour ?? 23;
      displayStartHour = min(7, displayStartHour);

      displayEndHour = weekSchedule?.getEndTime()?.hour ?? 0;
      displayEndHour = max(displayEndHour + 1, 17);
    } else {
      clippedDateStart = currentDateStart;
      clippedDateEnd = currentDateEnd;
    }

    notifyListeners("weekSchedule");
  }

  Future nextWeek() async {
    currentDateStart = toNextWeek(currentDateStart);
    currentDateEnd = toNextWeek(currentDateEnd);

    didUpdateScheduleIntoFuture = true;

    await updateSchedule();
  }

  Future previousWeek() async {
    currentDateStart = toPreviousWeek(currentDateStart);
    currentDateEnd = toPreviousWeek(currentDateEnd);

    didUpdateScheduleIntoFuture = false;

    await updateSchedule();
  }

  Future goToToday() async {
    var now = DateTime.now();

    didUpdateScheduleIntoFuture = currentDateStart?.isBefore(now) ?? false;

    currentDateStart = toStartOfDay(toMonday(now));
    currentDateEnd = currentDateStart.add(Duration(days: 5));

    await updateSchedule();
  }

  Future updateSchedule() async {
    if (_updateScheduleCancellationToken != null) {
      _updateScheduleCancellationToken.cancel();
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
    var cachedSchedule = await scheduleProvider.getCachedSchedule(
      currentDateStart,
      currentDateEnd,
    );

    if (_updateScheduleCancellationToken?.isCancelled() ?? true) return;

    _setSchedule(cachedSchedule);
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

      _setSchedule(updatedSchedule);
    } on OperationCancelledException {} on ScheduleQueryFailedException {
      updateFailed = true;
      notifyListeners("updateFailed");
      _cancelErrorInFuture();
    }
  }

  void _cancelErrorInFuture() async {
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

  void _startUpdateNowTimer() {
    if (_updateNowTimer == null) {
      _updateNowTimer = Timer.periodic(Duration(minutes: 2), (_) {
        now = DateTime.now();
        notifyListeners("now");
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    _updateNowTimer?.cancel();
    _updateNowTimer = null;

    _errorResetTimer?.cancel();
    _errorResetTimer = null;
  }
}
