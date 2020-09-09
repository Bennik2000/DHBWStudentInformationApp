import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
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

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScheduleViewModel viewModel = Provider.of<BaseViewModel>(context);

    if (!viewModel.didSetupProperly) {
      return ScheduleEmptyState();
    } else {
      return PagerWidget(
        pages: <PageDefinition>[
          PageDefinition(
            icon: Icon(Icons.view_week),
            text: Text(L.of(context).pageWeekOverviewTitle),
            builder: (_) => WeeklySchedulePage(),
            viewModel: WeeklyScheduleViewModel(
              KiwiContainer().resolve(),
            ),
          ),
          PageDefinition(
            icon: Icon(Icons.view_day),
            text: Text(L.of(context).pageDayOverviewTitle),
            builder: (_) => DailySchedulePage(),
            viewModel: DailyScheduleViewModel(
              KiwiContainer().resolve(),
            ),
          ),
        ],
      );
    }
  }
}
