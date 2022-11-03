import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/schedule/ui/dailyschedule/daily_schedule_page.dart';
import 'package:dhbwstudentapp/schedule/ui/viewmodels/daily_schedule_view_model.dart';
import 'package:dhbwstudentapp/schedule/ui/viewmodels/schedule_view_model.dart';
import 'package:dhbwstudentapp/schedule/ui/viewmodels/weekly_schedule_view_model.dart';
import 'package:dhbwstudentapp/schedule/ui/weeklyschedule/weekly_schedule_page.dart';
import 'package:dhbwstudentapp/schedule/ui/widgets/schedule_empty_state.dart';
import 'package:dhbwstudentapp/ui/pager_widget.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final WeeklyScheduleViewModel weeklyScheduleViewModel =
      WeeklyScheduleViewModel(
    KiwiContainer().resolve(),
    KiwiContainer().resolve(),
  );

  final DailyScheduleViewModel dailyScheduleViewModel = DailyScheduleViewModel(
    KiwiContainer().resolve(),
  );

  @override
  Widget build(BuildContext context) {
    final ScheduleViewModel viewModel = Provider.of<ScheduleViewModel>(context);

    if (!viewModel.didSetupProperly) {
      return ScheduleEmptyState();
    } else {
      return PagerWidget(
        pages: [
          PageDefinition<WeeklyScheduleViewModel>(
            icon: const Icon(Icons.view_week),
            text: L.of(context).pageWeekOverviewTitle,
            builder: (_) => const WeeklySchedulePage(),
            viewModel: weeklyScheduleViewModel,
          ),
          PageDefinition<DailyScheduleViewModel>(
            icon: const Icon(Icons.view_day),
            text: L.of(context).pageDayOverviewTitle,
            builder: (_) => const DailySchedulePage(),
            viewModel: dailyScheduleViewModel,
          ),
        ],
      );
    }
  }
}
