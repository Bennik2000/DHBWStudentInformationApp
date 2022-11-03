import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/common/util/date_utils.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_provider.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';

class DailyScheduleViewModel extends BaseViewModel {
  static const Duration weekDuration = Duration(days: 7);

  final ScheduleProvider scheduleProvider;

  DateTime? currentDate;

  Schedule? _daySchedule;

  DailyScheduleViewModel(this.scheduleProvider) {
    scheduleProvider.addScheduleUpdatedCallback(_scheduleUpdatedCallback);

    loadScheduleForToday();
  }

  set schedule(Schedule schedule) {
    _daySchedule = schedule;
    notifyListeners("daySchedule");
  }

  Schedule get daySchedule => _daySchedule ??= Schedule();

  Future loadScheduleForToday() async {
    var now = DateTime.now();
    currentDate = toStartOfDay(now);

    await updateSchedule();
  }

  Future updateSchedule() async {
    await _updateScheduleFromCache();
  }

  Future _updateScheduleFromCache() async {
    schedule = await scheduleProvider.getCachedSchedule(
      currentDate!,
      tomorrow(currentDate)!,
    );
  }

  Future<void> _scheduleUpdatedCallback(
    Schedule schedule,
    DateTime? start,
    DateTime? end,
  ) async {
    start = toStartOfDay(start);
    end = toStartOfDay(tomorrow(end));

    if (!(start!.isAfter(currentDate!) || end!.isBefore(currentDate!))) {
      schedule = schedule.trim(
        toStartOfDay(currentDate),
        toStartOfDay(tomorrow(currentDate)),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    scheduleProvider.removeScheduleUpdatedCallback(
      _scheduleUpdatedCallback,
    );
  }
}
