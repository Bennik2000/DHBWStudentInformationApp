import 'package:dhbwstuttgart/schedule/ui/viewmodels/schedule_view_model.dart';
import 'package:dhbwstuttgart/schedule/ui/widgets/schedule_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeeklySchedulePage extends StatefulWidget {
  @override
  _WeeklySchedulePageState createState() => _WeeklySchedulePageState();
}

class _WeeklySchedulePageState extends State<WeeklySchedulePage> {
  WeeklyScheduleViewModel viewModel;

  _WeeklySchedulePageState() {
    viewModel = WeeklyScheduleViewModel();
  }

  @override
  void initState() {
    super.initState();

    viewModel.refresh();
  }

  @override
  Widget build(BuildContext context) {
    var dailyWidgets = <Widget>[];

    var startDate = viewModel.currentDateStart;
    var endDate = startDate.add(Duration(days: 1));

    bool isFirst = true;

    while (startDate.isBefore(viewModel.currentDateEnd)) {
      dailyWidgets.add(Expanded(
        child: ScheduleWidget(
          schedule: viewModel.weekSchedule?.trim(startDate, endDate),
          displayStart: startDate,
          displayEnd: endDate,
          hideTimeLabels: !isFirst,
        ),
      ));

      isFirst = false;
      startDate = endDate;
      endDate = endDate.add(Duration(days: 1));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: dailyWidgets.sublist(0, 3),
    );
  }
}
