import 'package:dhbwstudentapp/common/data/database_entity.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_information.dart';

class ScheduleQueryInformationEntity extends DatabaseEntity {
  ScheduleQueryInformation? _scheduleQueryInformation;

  ScheduleQueryInformationEntity.fromModel(
    ScheduleQueryInformation scheduleQueryInformation,
  ) {
    _scheduleQueryInformation = scheduleQueryInformation;
  }

  ScheduleQueryInformationEntity.fromMap(Map<String, dynamic> map) {
    fromMap(map);
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    DateTime? startDate;
    if (map["start"] != null) {
      startDate = DateTime.fromMillisecondsSinceEpoch(map["start"]);
    }

    DateTime? endDate;
    if (map["end"] != null) {
      endDate = DateTime.fromMillisecondsSinceEpoch(map["end"]);
    }

    DateTime? queryTimeDate;
    if (map["queryTime"] != null) {
      queryTimeDate = DateTime.fromMillisecondsSinceEpoch(map["queryTime"]);
    }

    _scheduleQueryInformation =
        ScheduleQueryInformation(startDate, endDate, queryTimeDate);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "start": _scheduleQueryInformation!.start.millisecondsSinceEpoch,
      "end": _scheduleQueryInformation!.end.millisecondsSinceEpoch,
      "queryTime": _scheduleQueryInformation!.queryTime?.millisecondsSinceEpoch,
    };
  }

  ScheduleQueryInformation? asScheduleQueryInformation() =>
      _scheduleQueryInformation;

  static String tableName() => "ScheduleQueryInformation";
}
