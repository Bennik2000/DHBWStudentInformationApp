import 'package:dhbwstudentapp/common/ui/text_theme.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:flutter/material.dart';

typedef ScheduleEntryTapCallback = Function(ScheduleEntry entry);

class ScheduleEntryWidget extends StatelessWidget {
  final ScheduleEntry scheduleEntry;
  final ScheduleEntryTapCallback? onScheduleEntryTap;

  const ScheduleEntryWidget({
    Key? key,
    required this.scheduleEntry,
    this.onScheduleEntryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = scheduleEntry.type.color(context);

    Theme.of(context).textTheme.bodyText1!.copyWith();

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final customTextThme = theme.extension<CustomTextTheme>()!;
    final textStyle =
        textTheme.headline1?.merge(customTextThme.scheduleEntryWidgetTitle);

    return Card(
      color: color,
      elevation: 5,
      margin: const EdgeInsets.fromLTRB(1, 0, 1, 0),
      child: InkWell(
        onTap: () {
          onScheduleEntryTap?.call(scheduleEntry);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
          child: Text(
            scheduleEntry.title,
            softWrap: true,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.left,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
