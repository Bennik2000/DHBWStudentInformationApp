import 'package:dhbwstudentapp/schedule/service/rapla/rapla_schedule_source.dart';
import 'package:test/test.dart';

void main() {
  test('debugging', () async {
    // ignore: unused_local_variable
    final source = RaplaScheduleSource(
      raplaUrl:
          "https://rapla.dhbw-stuttgart.de/rapla?key=txB1FOi5xd1wUJBWuX8lJhGDUgtMSFmnKLgAG_NVMhCn4AzVqTBQM-yMcTKkIDCa",
    );

    //var schedule = await source.querySchedule(
    //    DateTime(2020, 01, 20), DateTime(2020, 01, 25));
    //print(schedule);
  });
}
