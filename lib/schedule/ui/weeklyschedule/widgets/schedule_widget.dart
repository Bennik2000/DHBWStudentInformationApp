import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/schedule_theme.dart';
import 'package:dhbwstudentapp/common/ui/text_theme.dart';
import 'package:dhbwstudentapp/common/util/date_utils.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:dhbwstudentapp/schedule/ui/weeklyschedule/widgets/schedule_entry_alignment.dart';
import 'package:dhbwstudentapp/schedule/ui/weeklyschedule/widgets/schedule_entry_widget.dart';
import 'package:dhbwstudentapp/schedule/ui/weeklyschedule/widgets/schedule_grid.dart';
import 'package:dhbwstudentapp/schedule/ui/weeklyschedule/widgets/schedule_past_overlay.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleWidget extends StatelessWidget {
  final Schedule? schedule;
  final DateTime? displayStart;
  final DateTime? displayEnd;
  final DateTime now;
  final int displayStartHour;
  final int displayEndHour;
  final ScheduleEntryTapCallback onScheduleEntryTap;

  const ScheduleWidget({
    super.key,
    required this.schedule,
    required this.displayStart,
    required this.displayEnd,
    required this.onScheduleEntryTap,
    required this.now,
    required this.displayStartHour,
    required this.displayEndHour,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: buildWithSize,
    );
  }

  Widget buildWithSize(BuildContext context, BoxConstraints constraints) {
    final scheduleTheme = Theme.of(context).extension<ScheduleTheme>()!;

    final height = constraints.biggest.height;
    final width = constraints.biggest.width;

    const dayLabelsHeight = 40.0;
    const timeLabelsWidth = 50.0;

    final hourHeight =
        (height - dayLabelsHeight) / (displayEndHour - displayStartHour);
    final minuteHeight = hourHeight / 60;

    final days = calculateDisplayedDays();

    final labelWidgets = buildLabelWidgets(
      context,
      hourHeight,
      (width - timeLabelsWidth) / days,
      dayLabelsHeight,
      timeLabelsWidth,
      hourHeight,
      minuteHeight,
    );

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
        ScheduleGrid(
          displayStartHour,
          displayEndHour,
          timeLabelsWidth,
          dayLabelsHeight,
          days,
          scheduleTheme.scheduleGridGridLines,
        ),
        Padding(
          padding:
              const EdgeInsets.fromLTRB(timeLabelsWidth, dayLabelsHeight, 0, 0),
          child: Stack(
            children: entryWidgets,
          ),
        ),
        Stack(
          children: labelWidgets,
        ),
        Padding(
          padding:
              const EdgeInsets.fromLTRB(timeLabelsWidth, dayLabelsHeight, 0, 0),
          child: SchedulePastOverlay(
            displayStartHour,
            displayEndHour,
            scheduleTheme.scheduleInPastOverlay,
            displayStart,
            displayEnd,
            now,
            days,
          ),
        )
      ],
    );
  }

  int calculateDisplayedDays() {
    final startEndDifference =
        toStartOfDay(displayEnd)?.difference(toStartOfDay(displayStart)!);

    var days = (startEndDifference?.inDays ?? 0) + 1;

    if (days > 7) {
      days = 7;
    } else if (days < 5) {
      days = 5;
    }
    return days;
  }

  List<Widget> buildLabelWidgets(
    BuildContext context,
    double rowHeight,
    double columnWidth,
    double dayLabelHeight,
    double timeLabelWidth,
    double hourHeight,
    double minuteHeight,
  ) {
    final labelWidgets = <Widget>[];

    for (var i = displayStartHour; i < displayEndHour; i++) {
      final hourLabelText = "$i:00";

      labelWidgets.add(
        Positioned(
          top: rowHeight * (i - displayStartHour) + dayLabelHeight,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
            child: Text(hourLabelText),
          ),
        ),
      );
    }

    var i = 0;

    final dayFormatter = DateFormat("E", L.of(context).locale.languageCode);
    final dateFormatter =
        DateFormat("d. MMM", L.of(context).locale.languageCode);

    final loopEnd = toStartOfDay(tomorrow(displayEnd))!;

    final textTheme = Theme.of(context).textTheme;
    final customTextThme = Theme.of(context).extension<CustomTextTheme>();
    final scheduleWidgetColumnTitleDay = textTheme.subtitle2
        ?.merge(customTextThme?.scheduleWidgetColumnTitleDay);

    for (var columnDate = toStartOfDay(displayStart)!;
        columnDate.isBefore(loopEnd);
        columnDate = tomorrow(columnDate)!) {
      labelWidgets.add(
        Positioned(
          top: 0,
          left: columnWidth * i + timeLabelWidth,
          width: columnWidth,
          height: dayLabelHeight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  dayFormatter.format(columnDate),
                  style: scheduleWidgetColumnTitleDay,
                ),
                Text(dateFormatter.format(columnDate)),
              ],
            ),
          ),
        ),
      );

      i++;
    }

    return labelWidgets;
  }

  List<Widget> buildEntryWidgets(
    double hourHeight,
    double minuteHeight,
    double width,
    int columns,
  ) {
    if (schedule == null) return <Widget>[];
    if (schedule!.entries.isEmpty) return <Widget>[];

    final entryWidgets = <Widget>[];

    final columnWidth = width / columns;

    DateTime? columnStartDate = toStartOfDay(displayStart);
    DateTime? columnEndDate = tomorrow(columnStartDate);

    for (int i = 0; i < columns; i++) {
      final xPosition = columnWidth * i;
      final maxWidth = columnWidth;

      final columnSchedule = schedule!.trim(columnStartDate, columnEndDate);

      entryWidgets.addAll(
        buildEntryWidgetsForColumn(
          maxWidth,
          hourHeight,
          minuteHeight,
          xPosition,
          columnSchedule.entries,
        ),
      );

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
    final entryWidgets = <Widget>[];

    final laidOutEntries =
        const ScheduleEntryAlignmentAlgorithm().layoutEntries(entries);

    for (final value in laidOutEntries) {
      final entry = value.entry;

      final yStart = hourHeight * (entry.start.hour - displayStartHour) +
          minuteHeight * entry.start.minute;

      final yEnd = hourHeight * (entry.end.hour - displayStartHour) +
          minuteHeight * entry.end.minute;

      final entryLeft = maxWidth * value.leftColumn;
      final entryWidth = maxWidth * (value.rightColumn - value.leftColumn);

      final widget = Positioned(
        top: yStart,
        left: entryLeft + xPosition,
        height: yEnd - yStart,
        width: entryWidth,
        child: ScheduleEntryWidget(
          scheduleEntry: entry,
          onScheduleEntryTap: onScheduleEntryTap,
        ),
      );

      entryWidgets.add(widget);
    }

    return entryWidgets;
  }
}
