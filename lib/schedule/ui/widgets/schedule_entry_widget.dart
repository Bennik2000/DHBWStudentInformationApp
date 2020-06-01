import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef ScheduleEntryTapCallback = Function(ScheduleEntry entry);

class ScheduleEntryWidget extends StatelessWidget {
  final ScheduleEntry scheduleEntry;
  final ScheduleEntryTapCallback onScheduleEntryTap;

  const ScheduleEntryWidget({
    Key key,
    this.scheduleEntry,
    this.onScheduleEntryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (scheduleEntry.type) {
      case ScheduleEntryType.PublicHoliday:
        color = Colors.blueGrey;
        break;
      case ScheduleEntryType.Class:
        color = Colors.green;
        break;
      case ScheduleEntryType.Exam:
        color = Colors.red;
        break;
      case ScheduleEntryType.Unknown:
        color = Colors.grey;
        break;
      case ScheduleEntryType.Online:
        color = Colors.lime;
        break;
    }

    return Card(
      color: color,
      elevation: 5,
      margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: InkWell(
        onTap: () {
          if (onScheduleEntryTap != null) onScheduleEntryTap(scheduleEntry);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Text(
                  scheduleEntry.title,
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                flex: 0,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
