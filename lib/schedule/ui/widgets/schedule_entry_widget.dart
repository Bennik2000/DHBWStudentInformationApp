import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

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
    var formatter = new DateFormat('HH:mm');
    var timeStart = formatter.format(scheduleEntry.start);
    var timeEnd = formatter.format(scheduleEntry.end);

    return Card(
      color: Colors.red,
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
              /*Text(
                timeStart,
                style: TextStyle(fontSize: 13),
              )*/
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
              //Text(scheduleEntry.details),
              /*Text(
                timeEnd,
                style: TextStyle(fontSize: 14),
              )*/
            ],
          ),
        ),
      ),
    );
  }
}
