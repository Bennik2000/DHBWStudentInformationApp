import 'package:dhbwstuttgart/schedule/model/schedule.dart';

abstract class ScheduleSource {
  Future<Schedule> querySchedule(DateTime from, DateTime to);
}
