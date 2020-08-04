import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/schedule/ui/dailyschedule/daily_schedule_page.dart';
import 'package:dhbwstudentapp/schedule/ui/dailyschedule/viewmodels/daily_schedule_view_model.dart';
import 'package:dhbwstudentapp/schedule/ui/weeklyschedule/viewmodels/weekly_schedule_view_model.dart';
import 'package:dhbwstudentapp/schedule/ui/weeklyschedule/weekly_schedule_page.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:dhbwstudentapp/ui/navigation/pageable_navigation_entry.dart';
import 'package:dhbwstudentapp/ui/navigation/single_navigation_entry.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class ScheduleNavigationEntry extends PageableNavigationEntry {
  @override
  Widget icon(BuildContext context) {
    return Icon(Icons.calendar_today);
  }

  @override
  List<NavigationEntry> initPages() {
    return <NavigationEntry>[
      FixedSingleNavigationEntry(
        builder: (_) => WeeklySchedulePage(),
        iconBuilder: (_) => Icon(Icons.view_week),
        pageKey: Key("Weekly"),
        titleBuilder: (BuildContext context) =>
            L.of(context).pageWeekOverviewTitle,
        viewModelBuilder: () =>
            WeeklyScheduleViewModel(KiwiContainer().resolve()),
      ),
      FixedSingleNavigationEntry(
        builder: (_) => DailySchedulePage(),
        iconBuilder: (_) => Icon(Icons.calendar_view_day),
        pageKey: Key("Daily"),
        titleBuilder: (BuildContext context) =>
            L.of(context).pageDayOverviewTitle,
        viewModelBuilder: () =>
            DailyScheduleViewModel(KiwiContainer().resolve()),
      ),
    ];
  }

  @override
  String title(BuildContext context) {
    return L.of(context).screenScheduleTitle;
  }
}
