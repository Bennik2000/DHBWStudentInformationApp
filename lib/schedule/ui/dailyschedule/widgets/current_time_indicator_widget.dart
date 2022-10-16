import 'package:dhbwstudentapp/common/ui/schedule_theme.dart';
import 'package:flutter/material.dart';

class CurrentTimeIndicatorWidget extends StatelessWidget {
  const CurrentTimeIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleTheme = Theme.of(context).extension<ScheduleTheme>()!;

    return Row(
      children: <Widget>[
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: scheduleTheme.currentTimeIndicator,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: scheduleTheme.currentTimeIndicator,
          ),
        )
      ],
    );
  }
}
