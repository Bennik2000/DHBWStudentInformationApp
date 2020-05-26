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
    return SingleChildScrollView(
      child: Container(
        height: 1000,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return buildWithSize(
              context, constraints.biggest.width, constraints.biggest.height);
        }),
      ),
    );
  }

  Widget buildWithSize(BuildContext context, double width, double height) {
    var hourHeight = height / (displayEndHour - displayStartHour);
    var minuteHeight = hourHeight / 60;

    List<Widget> entryWidgets = buildEntryWidgets(hourHeight, minuteHeight);
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

  List<Widget> buildEntryWidgets(double hourHeight, double minuteHeight) {
    var entryWidgets = List<Widget>();

    for (ScheduleEntry value in schedule?.entries ?? []) {
      var yStart = hourHeight * (value.start.hour - displayStartHour) +
          minuteHeight * value.start.minute;

      var yEnd = hourHeight * (value.end.hour - displayStartHour) +
          minuteHeight * value.end.minute;

      var widget = Positioned(
        top: yStart,
        left: 0,
        height: yEnd - yStart,
        right: 0,
        child: ScheduleEntryWidget(scheduleEntry: value),
      );

      entryWidgets.add(widget);
    }
    return entryWidgets;
  }
}
