import 'dart:async';
import 'dart:math';

import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/common/util/cancelable_mutex.dart';
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

  DateTime get now => DateTime.now();

  Timer _errorResetTimer;
  Timer _updateNowTimer;

  final CancelableMutex _updateMutex = CancelableMutex();
  
  DateTime lastRequestedStart;
  DateTime lastRequestedEnd;

  WeeklyScheduleViewModel(this.scheduleProvider) {
    goToToday();
    ensureUpdateNowTimerRunning();
  }

  void _setSchedule(Schedule schedule, DateTime start, DateTime end) {
    weekSchedule = schedule;
    didUpdateScheduleIntoFuture = currentDateStart?.isBefore(start) ?? true;
    currentDateStart = start;
    currentDateEnd = end;

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
    await updateSchedule(
      toNextWeek(currentDateStart),
      toNextWeek(currentDateEnd),
    );
  }

  Future previousWeek() async {
    await updateSchedule(
      toPreviousWeek(currentDateStart),
      toPreviousWeek(currentDateEnd),
    );
  }

  Future goToToday() async {
    currentDateStart = toStartOfDay(toMonday(DateTime.now()));
    currentDateEnd = currentDateStart.add(const Duration(days: 5));

    await updateSchedule(currentDateStart, currentDateEnd);
  }

  Future updateSchedule(DateTime start, DateTime end) async {
    lastRequestedEnd = end;
    lastRequestedStart = start;

    await _updateMutex.acquireAndCancelOther();

    if (lastRequestedStart != start || lastRequestedEnd != end) {
      _updateMutex.release();
      return;
    }

    try {
      isUpdating = true;
      notifyListeners("isUpdating");

      await _doUpdateSchedule(start, end);
    } catch (_) {} finally {
      isUpdating = false;
      _updateMutex.release();
      notifyListeners("isUpdating");
    }
  }

  Future _doUpdateSchedule(DateTime start, DateTime end) async {
    print("Refreshing schedule...");

    var cancellationToken = _updateMutex.token;

    var cachedSchedule = await scheduleProvider.getCachedSchedule(start, end);
    cancellationToken.throwIfCancelled();
    _setSchedule(cachedSchedule, start, end);

    var updatedSchedule = await _readScheduleFromService(
      start,
      end,
      cancellationToken,
    );
    cancellationToken.throwIfCancelled();

    if (updatedSchedule != null) {
      _setSchedule(updatedSchedule, start, end);
    }

    updateFailed = updatedSchedule == null;
    notifyListeners("updateFailed");

    if (updateFailed) {
      _cancelErrorInFuture();
    }

    print("Refreshing done");
  }

  Future _readScheduleFromService(
    DateTime start,
    DateTime end,
    CancellationToken token,
  ) async {
    try {
      return await scheduleProvider.getUpdatedSchedule(
        start,
        end,
        token,
      );
    } on OperationCancelledException {} on ScheduleQueryFailedException {}

    return null;
  }

  void _cancelErrorInFuture() {
    if (_errorResetTimer != null) {
      _errorResetTimer.cancel();
    }

    _errorResetTimer = Timer(
      const Duration(seconds: 5),
      () {
        updateFailed = false;
        notifyListeners("updateFailed");
      },
    );
  }

  void ensureUpdateNowTimerRunning() {
    if (_updateNowTimer == null || !_updateNowTimer.isActive) {
      _updateNowTimer = Timer.periodic(const Duration(minutes: 1), (_) {
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
