import 'package:dhbwstuttgart/schedule/model/schedule.dart';
import 'package:dhbwstuttgart/schedule/service/rapla/rapla_schedule_source.dart';

class WeeklyScheduleViewModel {
  static const Duration weekDuration = Duration(days: 7);

  Schedule weekSchedule;
  DateTime currentDateStart;
  DateTime currentDateEnd;

  bool isUpdating = false;

  WeeklyScheduleViewModel() {
    var now = DateTime.now();
    currentDateStart = DateTime(now.year, now.month, now.day);
    currentDateStart =
        currentDateStart.subtract(Duration(days: currentDateStart.weekday));
    currentDateEnd = currentDateStart.add(weekDuration);
  }

  Future nextWeek() async {
    currentDateStart = currentDateStart.add(weekDuration);
    currentDateEnd = currentDateEnd.add(weekDuration);

    await refresh();
  }

  Future previousWeek() async {
    currentDateStart = currentDateStart.subtract(weekDuration);
    currentDateEnd = currentDateEnd.subtract(weekDuration);

    await refresh();
  }

  Future refresh() async {
    // X fetch data from rapla
    // - generate diff to database
    // - store updated entries in database
    // - update daily schedules

    weekSchedule = await RaplaScheduleSource(
            "https://rapla.dhbw-stuttgart.de/rapla?key=txB1FOi5xd1wUJBWuX8lJhGDUgtMSFmnKLgAG_NVMhCn4AzVqTBQM-yMcTKkIDCa")
        .querySchedule(currentDateStart, currentDateEnd);
  }
}
