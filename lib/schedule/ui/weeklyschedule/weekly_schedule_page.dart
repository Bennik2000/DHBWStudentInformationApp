import 'package:dhbwstuttgart/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstuttgart/common/ui/colors.dart';
import 'package:dhbwstuttgart/common/ui/text_styles.dart';
import 'package:dhbwstuttgart/schedule/model/schedule.dart';
import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';
import 'package:dhbwstuttgart/schedule/ui/schedule_entry_detail_bottom_sheet.dart';
import 'package:dhbwstuttgart/schedule/ui/weeklyschedule/viewmodels/weekly_schedule_view_model.dart';
import 'package:dhbwstuttgart/schedule/ui/weeklyschedule/widgets/schedule_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

class WeeklySchedulePage extends StatefulWidget {
  @override
  _WeeklySchedulePageState createState() => _WeeklySchedulePageState();
}

class _WeeklySchedulePageState extends State<WeeklySchedulePage> {
  WeeklyScheduleViewModel viewModel;
  Schedule schedule;

  _WeeklySchedulePageState();

  @override
  void initState() {
    super.initState();
  }

  void _previousWeek() async {
    await viewModel?.previousWeek();
  }

  void _nextWeek() async {
    await viewModel?.nextWeek();
  }

  void _goToToday() async {
    await viewModel?.goToToday();
  }

  void _onScheduleEntryTap(BuildContext context, ScheduleEntry entry) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ScheduleEntryDetailBottomSheet(
        scheduleEntry: entry,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<BaseViewModel>(context);

    return PropertyChangeProvider(
      value: viewModel,
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.chevron_left),
                    onPressed: _previousWeek,
                  ),
                  FlatButton(
                    child: Icon(Icons.today),
                    onPressed: _goToToday,
                  ),
                  FlatButton(
                    child: Icon(Icons.chevron_right),
                    onPressed: _nextWeek,
                  ),
                ],
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    PropertyChangeConsumer(
                      properties: ["weekSchedule", "now"],
                      builder: (BuildContext context,
                          WeeklyScheduleViewModel model, Set properties) {
                        return ScheduleWidget(
                          schedule: model.weekSchedule,
                          displayStart:
                              model.clippedDateStart ?? model.currentDateStart,
                          displayEnd:
                              model.clippedDateEnd ?? model.currentDateEnd,
                          onScheduleEntryTap: (entry) {
                            _onScheduleEntryTap(context, entry);
                          },
                          now: model.now,
                          displayEndHour: model.displayEndHour,
                          displayStartHour: model.displayStartHour,
                        );
                      },
                    ),
                    PropertyChangeConsumer(
                      properties: ["isUpdating"],
                      builder: (BuildContext context,
                          WeeklyScheduleViewModel model, Set properties) {
                        return model.isUpdating
                            ? LinearProgressIndicator()
                            : Container();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          buildErrorDisplay(context)
        ],
      ),
    );
  }

  Widget buildErrorDisplay(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        PropertyChangeConsumer(
          properties: [
            "updateFailed",
          ],
          builder: (BuildContext context, WeeklyScheduleViewModel model,
                  Set properties) =>
              AnimatedSwitcher(
            child: model.updateFailed
                ? Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      width: double.infinity,
                      color: colorNoConnectionBackground(),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
                        child: Text(
                          "Keine Verbindung!",
                          textAlign: TextAlign.center,
                          style: textStyleUpdateNoConnection(context),
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: double.infinity,
                  ),
            duration: Duration(milliseconds: 300),
          ),
        ),
      ],
    );
  }
}
