import 'package:dhbwstuttgart/common/util/date_utils.dart';
import 'package:dhbwstuttgart/schedule/model/schedule.dart';
import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';
import 'package:dhbwstuttgart/schedule/ui/widgets/schedule_entry_widget.dart';
import 'package:dhbwstuttgart/schedule/ui/widgets/schedule_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScheduleWidget extends StatelessWidget {
  final Schedule schedule;
  final DateTime displayStart;
  final DateTime displayEnd;
  final int displayStartHour = 7;
  final int displayEndHour = 19;

  const ScheduleWidget({
    Key key,
    this.schedule,
    this.displayStart,
    this.displayEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return buildWithSize(
            context, constraints.biggest.width, constraints.biggest.height);
      }),
    );
  }

  Widget buildWithSize(BuildContext context, double width, double height) {
    var hourHeight = height / (displayEndHour - displayStartHour);
    var minuteHeight = hourHeight / 60;

    List<Widget> entryWidgets =
        buildEntryWidgets(hourHeight, minuteHeight, width - 50 - 20);

    List<Widget> labelWidgets = buildTimeLabelWidgets(hourHeight);

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ScheduleGrid(displayStartHour, displayEndHour, 50),
        Padding(
          padding: EdgeInsets.fromLTRB(50, 0, 20, 0),
          child: Stack(
            children: entryWidgets,
          ),
        ),
        Stack(
          children: labelWidgets,
        )
      ],
    );
  }

  List<Widget> buildTimeLabelWidgets(double hourHeight) {
    var labelWidgets = List<Widget>();

    for (var i = displayStartHour; i < displayEndHour; i++) {
      var hourLabelText = i.toString() + ":00";

      labelWidgets.add(Positioned(
        top: hourHeight * (i - displayStartHour),
        left: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
          child: Text(hourLabelText),
        ),
      ));
    }
    return labelWidgets;
  }

  List<Widget> buildEntryWidgets(
      double hourHeight, double minuteHeight, double width) {
    /*var entries = schedule?.entries ?? <ScheduleEntry>[];
    entries.sort((ScheduleEntry a1, ScheduleEntry a2) {
      return a1.start.compareTo(a2.start);
    });*/
    if (schedule == null) return <Widget>[];
    if (schedule.entries.length == 0) return <Widget>[];

    var entryWidgets = List<Widget>();

    var difference = schedule.getEndDate()?.difference(schedule.getStartDate());

    var hours = (difference?.inHours ?? 0) / 24.0;
    var days = hours.ceil();

    var columnWidth = width / days;

    DateTime columnStartDate = toStartOfDay(schedule.getStartDate());
    DateTime columnEndDate = tomorrow(columnStartDate);

    for (int i = 0; i < days; i++) {
      var xPosition = columnWidth * i;
      var maxWidth = columnWidth;

      var columnSchedule = schedule.trim(columnStartDate, columnEndDate);

      entryWidgets.addAll(buildEntryWidgetsForColumn(
        maxWidth,
        hourHeight,
        minuteHeight,
        xPosition,
        columnSchedule.entries,
      ));

      columnStartDate = columnEndDate;
      columnEndDate = tomorrow(columnEndDate);
    }

    return entryWidgets;
  }

  List<Widget> buildEntryWidgetsForColumn(
    double maxWidth,
    double hourHeight,
    double minuteHeight,
    double xPosition,
    List<ScheduleEntry> entries,
  ) {
    var entryWidgets = <Widget>[];

    for (ScheduleEntry value in entries) {
      var interferingEntries = getInterferingEntries(entries, value);
      var index = interferingEntries.indexOf(value);

      var yStart = hourHeight * (value.start.hour - displayStartHour) +
          minuteHeight * value.start.minute;

      var yEnd = hourHeight * (value.end.hour - displayStartHour) +
          minuteHeight * value.end.minute;

      var entryLeft = (maxWidth / interferingEntries.length) * index;
      var entryWidth = maxWidth / interferingEntries.length;

      var widget = Positioned(
        top: yStart,
        left: entryLeft + xPosition,
        height: yEnd - yStart,
        width: entryWidth,
        child: ScheduleEntryWidget(scheduleEntry: value),
      );

      entryWidgets.add(widget);
    }

    return entryWidgets;
  }

  List<ScheduleEntry> getInterferingEntries(
      List<ScheduleEntry> entries, ScheduleEntry entry) {
    var interferences = <ScheduleEntry>[];

    for (var possibleInterference in entries) {
      if (possibleInterference == entry) {
        interferences.add(entry);
        continue;
      }
      if (possibleInterference.start.isBefore(entry.end) &&
          possibleInterference.end.isAfter(entry.start))
        interferences.add(possibleInterference);
    }

    return interferences;
  }
}
