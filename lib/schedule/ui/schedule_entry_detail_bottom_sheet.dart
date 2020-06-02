import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ScheduleEntryDetailBottomSheet extends StatelessWidget {
  final ScheduleEntry scheduleEntry;

  const ScheduleEntryDetailBottomSheet({Key key, this.scheduleEntry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('HH:mm');
    var timeStart = formatter.format(scheduleEntry.start);
    var timeEnd = formatter.format(scheduleEntry.end);

    var typeString;

    switch (scheduleEntry.type) {
      case ScheduleEntryType.Unknown:
        typeString = "";
        break;
      case ScheduleEntryType.Class:
        typeString = "Vorlesung";
        break;
      case ScheduleEntryType.Online:
        typeString = "Online Vorlesung";
        break;
      case ScheduleEntryType.PublicHoliday:
        typeString = "Feiertag";
        break;
      case ScheduleEntryType.Exam:
        typeString = "Klausur / Prüfung";
        break;
    }

    return Container(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            "Von: ",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            timeStart,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            "Bis: ",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            timeEnd,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Text(
                        scheduleEntry.title ?? "",
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    scheduleEntry.professor ?? "",
                  ),
                  Text(
                    typeString,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            scheduleEntry.details?.isEmpty ?? true
                ? Container()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: Container(
                      color: Colors.grey,
                      height: 1,
                    ),
                  ),
            scheduleEntry.details?.isEmpty ?? true
                ? Container()
                : Text(scheduleEntry.details),
          ],
        ),
      ),
    );
  }
}
