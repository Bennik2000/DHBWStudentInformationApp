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
    var timeStart = formatter.format(scheduleEntry.start);
    var timeEnd = formatter.format(scheduleEntry.end);

    return Card(
      color: Colors.redAccent,
      elevation: 8,
      margin: EdgeInsets.fromLTRB(1, 0, 1, 0),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                timeStart,
                style: TextStyle(fontSize: 14),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Text(
                  scheduleEntry.title,
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                flex: 0,
                child: Container(),
              ),
              //Text(scheduleEntry.details),
              Text(
                timeEnd,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
