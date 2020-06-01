import 'dart:math';

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
  final ScheduleEntryTapCallback onScheduleEntryTap;

  const ScheduleWidget({
    Key key,
    this.schedule,
    this.displayStart,
    this.displayEnd,
    this.onScheduleEntryTap,
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

    var difference = displayEnd?.difference(displayStart);
    var days = max(5, ((difference?.inHours ?? 0) / 24.0).ceil());

    var labelWidgets = buildLabelWidgets(hourHeight, days);
    var entryWidgets = <Widget>[];

    if (schedule != null) {
      entryWidgets = buildEntryWidgets(
        hourHeight,
        minuteHeight,
        width - 50,
        days,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ScheduleGrid(displayStartHour, displayEndHour, 50, days),
        Padding(
          padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
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

  List<Widget> buildLabelWidgets(double hourHeight, int days) {
    var labelWidgets = List<Widget>();

    for (var i = displayStartHour; i < displayEndHour; i++) {
      var hourLabelText = i.toString() + ":00";

      labelWidgets.add(
        Positioned(
          top: hourHeight * (i - displayStartHour),
          left: 0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
            child: Text(hourLabelText),
          ),
        ),
      );
    }

    return labelWidgets;
  }

  List<Widget> buildEntryWidgets(
      double hourHeight, double minuteHeight, double width, int columns) {
    if (schedule == null) return <Widget>[];
    if (schedule.entries.length == 0) return <Widget>[];

    var entryWidgets = List<Widget>();

    var columnWidth = width / columns;

    DateTime columnStartDate = toStartOfDay(schedule.getStartDate());
    DateTime columnEndDate = tomorrow(columnStartDate);

    for (int i = 0; i < columns; i++) {
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
        child: ScheduleEntryWidget(
          scheduleEntry: value,
          onScheduleEntryTap: onScheduleEntryTap,
        ),
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
