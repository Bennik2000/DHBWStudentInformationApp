import 'package:dhbwstudentapp/common/ui/schedule_entry_type_mappings.dart';
import 'package:dhbwstudentapp/common/ui/text_styles.dart';
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
    Color color = scheduleEntryTypeToColor(context, scheduleEntry.type);

    return Card(
      color: color,
      elevation: 5,
      margin: const EdgeInsets.fromLTRB(1, 0, 1, 0),
      child: InkWell(
        onTap: () {
          if (onScheduleEntryTap != null) onScheduleEntryTap!(scheduleEntry);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
          child: Text(
            scheduleEntry.title,
            softWrap: true,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.left,
            style: textStyleScheduleEntryWidgetTitle(context),
          ),
        ),
      ),
    );
  }
}
