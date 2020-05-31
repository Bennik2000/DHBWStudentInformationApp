import 'package:dhbwstuttgart/schedule/model/schedule.dart';
import 'package:dhbwstuttgart/schedule/ui/viewmodels/schedule_view_model.dart';
import 'package:dhbwstuttgart/schedule/ui/widgets/schedule_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class WeeklySchedulePage extends StatefulWidget {
  @override
  _WeeklySchedulePageState createState() => _WeeklySchedulePageState();
}

class _WeeklySchedulePageState extends State<WeeklySchedulePage> {
  WeeklyScheduleViewModel viewModel;
  Schedule schedule;

  _WeeklySchedulePageState() {
    viewModel = WeeklyScheduleViewModel();
  }

  @override
  void initState() {
    super.initState();

    viewModel.updateSchedule();
  }

  void _previousWeek() async {
    await viewModel.previousWeek();
  }

  void _nextWeek() async {
    await viewModel.nextWeek();
  }

  void _goToToday() async {
    await viewModel.goToToday();
  }

  void _refresh() async {
    await viewModel.updateSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rapla"),
      ),
      body: PropertyChangeProvider(
        value: viewModel,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            PropertyChangeConsumer(
              properties: ["isUpdating"],
              builder: (BuildContext context, WeeklyScheduleViewModel model,
                  Set properties) {
                return Visibility(
                  child: LinearProgressIndicator(),
                  visible: viewModel.isUpdating,
                  maintainSize: true,
                );
              },
            ),
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
              child: PropertyChangeConsumer(
                properties: [
                  "weekSchedule",
                  "currentDateStart",
                  "currentDateEnd",
                ],
                builder: (BuildContext context, WeeklyScheduleViewModel model,
                    Set properties) {
                  return ScheduleWidget(
                    schedule: model.weekSchedule,
                    displayStart: model.currentDateStart,
                    displayEnd: model.currentDateEnd,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Refresh',
        child: new Icon(Icons.refresh),
      ),
    );
  }
}
