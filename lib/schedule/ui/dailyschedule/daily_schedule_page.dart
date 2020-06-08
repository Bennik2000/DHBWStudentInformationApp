import 'package:dhbwstuttgart/common/i18n/localizations.dart';
import 'package:dhbwstuttgart/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstuttgart/common/ui/text_styles.dart';
import 'package:dhbwstuttgart/schedule/ui/dailyschedule/viewmodels/daily_schedule_view_model.dart';
import 'package:dhbwstuttgart/schedule/ui/dailyschedule/widgets/current_time_indicator_widget.dart';
import 'package:dhbwstuttgart/schedule/ui/dailyschedule/widgets/daily_schedule_entry_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

class DailySchedulePage extends StatefulWidget {
  @override
  _DailySchedulePageState createState() => _DailySchedulePageState();
}

class _DailySchedulePageState extends State<DailySchedulePage> {
  DailyScheduleViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<BaseViewModel>(context);

    return PropertyChangeProvider(
      value: viewModel,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: PropertyChangeConsumer(
                  builder: (BuildContext context, DailyScheduleViewModel model,
                      Set properties) {
                    var dateFormat = DateFormat.yMMMMEEEEd(
                        L.of(context).locale.languageCode);
                    return Text(
                      dateFormat.format(model.currentDate),
                      style: textStyleDailyScheduleCurrentDate(context),
                    );
                  },
                ),
              ),
              (viewModel.daySchedule?.entries?.length ?? 0) == 0
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(flex: 1, child: Container()),
                          Expanded(
                            flex: 8,
                            child: Text(
                              L.of(context).dailyScheduleNoEntriesToday,
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: textStyleDailyScheduleNoEntries(context),
                            ),
                          ),
                          Expanded(flex: 1, child: Container()),
                        ],
                      ),
                    )
                  : Column(
                      children: buildEntryWidgets(),
                    )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildEntryWidgets() {
    var entryWidgets = <Widget>[];
    var now = DateTime.now();
    var nowIndicatorInserted = false;

    for (var entry in viewModel.daySchedule?.entries) {
      if (!nowIndicatorInserted && (entry.end.isAfter(now))) {
        entryWidgets.add(CurrentTimeIndicatorWidget());
        nowIndicatorInserted = true;
      }

      entryWidgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
          child: DailyScheduleEntryWidget(
            scheduleEntry: entry,
          ),
        ),
      );
    }
    if (!nowIndicatorInserted) entryWidgets.add(CurrentTimeIndicatorWidget());
    return entryWidgets;
  }
}
