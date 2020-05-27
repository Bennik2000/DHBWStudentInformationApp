import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ScheduleEntryWidget extends StatelessWidget {
  final ScheduleEntry scheduleEntry;

  const ScheduleEntryWidget({Key key, this.scheduleEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('HH:mm');
    var time = formatter.format(scheduleEntry.start) +
        " - " +
        formatter.format(scheduleEntry.end);

    return Card(
      color: Colors.redAccent,
      elevation: 8,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                time,
                style: TextStyle(fontSize: 15),
              ),
              Text(
                scheduleEntry.title,
                style: TextStyle(fontSize: 25),
              ),
              Flexible(
                child: Container(),
              ),
              Text(scheduleEntry.details),
            ],
          ),
        ),
      ),
    );
  }
}
