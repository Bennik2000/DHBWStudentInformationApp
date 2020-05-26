import 'package:dhbwstuttgart/schedule/model/schedule.dart';
import 'package:dhbwstuttgart/schedule/service/rapla/rapla_response_parser.dart';
import 'package:dhbwstuttgart/schedule/service/schedule_source.dart';
import 'package:http/http.dart' as http;

class RaplaScheduleSource extends ScheduleSource {
  final String raplaUrl;
  final RaplaResponseParser responseParser = new RaplaResponseParser();

  RaplaScheduleSource(this.raplaUrl);

  @override
  Future<Schedule> querySchedule(DateTime from, DateTime to) async {
    DateTime current = from;

    var schedule = Schedule();

    while (current.isBefore(to)) {
      var weekSchedule = await _fetchRaplaSource(current);
      schedule.merge(weekSchedule);

      current = current.add(Duration(days: 7));
    }

    return trimScheduleToStartAndEndDate(schedule, from, to);
  }

  Schedule trimScheduleToStartAndEndDate(
      Schedule schedule, DateTime from, DateTime to) {
    var allEntries = schedule.entries;

    var trimmedSchedule = Schedule();

    for (var entry in allEntries) {
      if (entry.end.isAfter(from) && entry.start.isBefore(to))
        trimmedSchedule.addEntry(entry);
    }

    return trimmedSchedule;
  }

  Future<Schedule> _fetchRaplaSource(DateTime date) async {
    var uri = Uri.parse(raplaUrl);
    var keyParameter = uri.queryParameters["key"];

    var requestUri = Uri.https(uri.authority, uri.path, {
      "key": keyParameter,
      "day": date.day.toString(),
      "month": date.month.toString(),
      "year": date.year.toString()
    });

    var response = await http.get(requestUri);
    return responseParser.parseSchedule(response.body);
  }
}
