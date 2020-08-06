import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/schedule/ui/dailyschedule/daily_schedule_page.dart';
import 'package:dhbwstudentapp/schedule/ui/dailyschedule/viewmodels/daily_schedule_view_model.dart';
import 'package:dhbwstudentapp/schedule/ui/weeklyschedule/viewmodels/weekly_schedule_view_model.dart';
import 'package:dhbwstudentapp/schedule/ui/weeklyschedule/weekly_schedule_page.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:dhbwstudentapp/ui/pager_widget.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class ScheduleNavigationEntry extends NavigationEntry {
  @override
  Widget icon(BuildContext context) {
    return Icon(Icons.calendar_today);
  }

  @override
  BaseViewModel initViewModel() {
    return WeeklyScheduleViewModel(KiwiContainer().resolve());
  }

  @override
  String title(BuildContext context) {
    return L.of(context).screenScheduleTitle;
  }

  @override
  Widget build(BuildContext context) {
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

  @override
  String get route => "/";
}
