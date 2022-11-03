import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';

class ScheduleEntryAlignmentInformation {
  final ScheduleEntry entry;

  late double leftColumn;
  late double rightColumn;

  ScheduleEntryAlignmentInformation(this.entry);
}

///
/// Event layout algorithm from here:
/// https://stackoverflow.com/questions/11311410/visualization-of-calendar-events-algorithm-to-layout-events-with-maximum-width
///
class ScheduleEntryAlignmentAlgorithm {
  List<ScheduleEntryAlignmentInformation> layoutEntries(
    List<ScheduleEntry> entries,
  ) {
    var events = entries
        .map(
          (e) => ScheduleEntryAlignmentInformation(e),
        )
        .toList();

    events.sort((e1, e2) {
      var result = e1.entry.start.compareTo(e2.entry.start);

      if (result == 0) {
        result = e2.entry.end.compareTo(e1.entry.end);
      }
      return result;
    });

    List<List<ScheduleEntryAlignmentInformation>> columns = [[]];

    DateTime? lastEventEnd;

    for (var event in events) {
      if (!event.entry.start
          .isBefore(lastEventEnd ?? DateTime.fromMillisecondsSinceEpoch(0))) {
        _packEvents(columns);
        columns.clear();
        lastEventEnd = null;
      }

      bool placed = false;

      // Try to put the event in one existing column.
      for (var column in columns) {
        if (!_entriesCollide(column.last.entry, event.entry)) {
          column.add(event);
          placed = true;
          break;
        }
      }

      // If the event could not be fit into one existing column, add a new one
      if (!placed) {
        columns.add([event]);
      }

      if (lastEventEnd == null || event.entry.end.isAfter(lastEventEnd)) {
        lastEventEnd = event.entry.end;
      }
    }

    _packEvents(columns);

    return events;
  }

  bool _entriesCollide(ScheduleEntry entry1, ScheduleEntry entry2) {
    return entry1.start.isBefore(entry2.end) &&
        entry2.start.isBefore(entry1.end);
  }

  void _packEvents(List<List<ScheduleEntryAlignmentInformation>> columns) {
    int columnIndex = 0;
    for (var column in columns) {
      for (var event in column) {
        var span = _expandEvent(event, columnIndex, columns);
        event.leftColumn = columnIndex / columns.length;
        event.rightColumn = (columnIndex + span) / columns.length;
      }
      columnIndex++;
    }
  }

  int _expandEvent(
    ScheduleEntryAlignmentInformation event,
    int columnIndex,
    List<List<ScheduleEntryAlignmentInformation>> columns,
  ) {
    var span = 1;
    for (var column in columns.skip(columnIndex + 1)) {
      for (var ev in column) {
        if (_entriesCollide(ev.entry, event.entry)) {
          return span;
        }
      }
      span++;
    }
    return span;
  }
}
