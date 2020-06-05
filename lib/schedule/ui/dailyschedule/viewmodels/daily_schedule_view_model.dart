import 'package:dhbwstuttgart/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstuttgart/common/util/date_utils.dart';
import 'package:dhbwstuttgart/schedule/business/schedule_provider.dart';
import 'package:dhbwstuttgart/schedule/model/schedule.dart';

class DailyScheduleViewModel extends BaseViewModel {
  static const Duration weekDuration = Duration(days: 7);

  final ScheduleProvider scheduleProvider;

  DateTime currentDate;

  Schedule daySchedule;

  DailyScheduleViewModel(this.scheduleProvider) {
    loadScheduleForToday();
  }

  Future setSchedule(Schedule schedule) async {
    daySchedule = schedule;
    notifyListeners("daySchedule");
  }

  Future loadScheduleForToday() async {
    var now = DateTime.now();
    currentDate = toStartOfDay(now);

    await updateSchedule();
  }

  Future updateSchedule() async {
    await _updateScheduleFromCache();
  }

  Future _updateScheduleFromCache() async {
    setSchedule(
      await scheduleProvider.getCachedSchedule(
        currentDate,
        tomorrow(currentDate),
      ),
    );
  }
}
