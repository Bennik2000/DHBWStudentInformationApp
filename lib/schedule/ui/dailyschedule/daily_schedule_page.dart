import 'package:dhbwstudentapp/assets.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/schedule/ui/dailyschedule/widgets/current_time_indicator_widget.dart';
import 'package:dhbwstudentapp/schedule/ui/dailyschedule/widgets/daily_schedule_entry_widget.dart';
import 'package:dhbwstudentapp/schedule/ui/viewmodels/daily_schedule_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

class DailySchedulePage extends StatefulWidget {
  const DailySchedulePage({Key? key}) : super(key: key);
  @override
  _DailySchedulePageState createState() => _DailySchedulePageState();
}

class _DailySchedulePageState extends State<DailySchedulePage> {
  late DailyScheduleViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<DailyScheduleViewModel>(context);

    final textTheme = Theme.of(context).textTheme;
    final dailyScheduleEntryTitle =
        textTheme.headline4?.copyWith(color: textTheme.headline5?.color);

    return PropertyChangeProvider<DailyScheduleViewModel, String>(
      value: viewModel,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: PropertyChangeConsumer<DailyScheduleViewModel, String>(
                  builder: (
                    BuildContext context,
                    DailyScheduleViewModel? model,
                    Set? properties,
                  ) {
                    final dateFormat = DateFormat.yMMMMEEEEd(
                      L.of(context).locale.languageCode,
                    );
                    return Text(
                      dateFormat.format(model!.currentDate!),
                      style: dailyScheduleEntryTitle,
                    );
                  },
                ),
              ),
              if (viewModel.schedule.entries.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(child: Container()),
                          Expanded(
                            flex: 8,
                            child: Text(
                              L.of(context).dailyScheduleNoEntriesToday,
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 64, 32, 32),
                        child: Opacity(
                          opacity: 0.9,
                          child: Image.asset(Assets.assets_empty_state_png),
                        ),
                      )
                    ],
                  ),
                )
              else
                Column(
                  children: buildEntryWidgets(),
                )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildEntryWidgets() {
    final entryWidgets = <Widget>[];
    final now = DateTime.now();
    var nowIndicatorInserted = false;

    for (final entry in viewModel.schedule.entries) {
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
