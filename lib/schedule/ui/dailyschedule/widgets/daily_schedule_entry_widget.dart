import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/app_theme.dart';
import 'package:dhbwstudentapp/common/ui/schedule_entry_type_mappings.dart';
import 'package:dhbwstudentapp/common/ui/text_theme.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyScheduleEntryWidget extends StatelessWidget {
  final ScheduleEntry scheduleEntry;

  const DailyScheduleEntryWidget({Key? key, required this.scheduleEntry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeFormatter = DateFormat.Hm(L.of(context).locale.languageCode);

    final startTime = timeFormatter.format(scheduleEntry.start);
    final endTime = timeFormatter.format(scheduleEntry.end);

    final textTheme = Theme.of(context).textTheme;
    final customTextThme = Theme.of(context).extension<CustomTextTheme>()!;
    final dailyScheduleEntryTitle =
        textTheme.headline4?.copyWith(color: textTheme.headline6?.color);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
              child: Column(
                children: <Widget>[
                  Text(
                    startTime,
                    style: textTheme.headline5
                        ?.merge(customTextThme.dailyScheduleEntryTimeStart),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      width: 1,
                      color: AppTheme.dailyScheduleTimeVerticalConnector,
                    ),
                  ),
                  Text(
                    endTime,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 8,
              color: scheduleEntry.type.color(context),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Text(
                        scheduleEntry.title,
                        style: dailyScheduleEntryTitle,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              scheduleEntry.professor,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Text(
                              scheduleEntryTypeToReadableString(
                                context,
                                scheduleEntry.type,
                              ),
                              style: textTheme.bodyText2?.merge(
                                  customTextThme.dailyScheduleEntryType,),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                            child: Text(
                              scheduleEntry.room,
                              softWrap: true,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ],
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
