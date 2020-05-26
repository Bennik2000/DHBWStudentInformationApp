import 'package:dhbwstuttgart/schedule/service/rapla/rapla_schedule_source.dart';
import 'package:test/test.dart';

void main() {
  test('debugging', () async {
    var source = RaplaScheduleSource(
        "https://rapla.dhbw-stuttgart.de/rapla?key=txB1FOi5xd1wUJBWuX8lJhGDUgtMSFmnKLgAG_NVMhCn4AzVqTBQM-yMcTKkIDCa");

    var schedule = await source.querySchedule(
        DateTime(2020, 05, 26), DateTime(2020, 05, 26));
  });
}
