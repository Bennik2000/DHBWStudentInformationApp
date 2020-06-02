import 'package:dhbwstuttgart/common/ui/schedule_entry_type_mappings.dart';
import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyScheduleEntryWidget extends StatelessWidget {
  final ScheduleEntry scheduleEntry;

  const DailyScheduleEntryWidget({Key key, this.scheduleEntry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (scheduleEntry == null) return Container();

    var timeFormatter = DateFormat("HH:mm");

    var startTime = timeFormatter.format(scheduleEntry.start);
    var endTime = timeFormatter.format(scheduleEntry.end);

    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    startTime,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Text(
                    endTime,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Card(
              margin: EdgeInsets.all(0),
              elevation: 8,
              color: scheduleEntryTypeToColor(scheduleEntry.type),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Text(
                        scheduleEntry.title,
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Text(
                      scheduleEntry.professor,
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 0.15,
                      ),
                    ),
                    Text(
                      scheduleEntryTypeToReadableString(scheduleEntry.type),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
