import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/schedule/ui/schedule_page.dart';
import 'package:dhbwstudentapp/schedule/ui/viewmodels/schedule_view_model.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class ScheduleNavigationEntry extends NavigationEntry {
  @override
  Widget icon(BuildContext context) {
    return Icon(Icons.calendar_today);
  }

  @override
  BaseViewModel initViewModel() {
    return ScheduleViewModel(
      KiwiContainer().resolve(),
    );
  }

  @override
  String title(BuildContext context) {
    return L.of(context).screenScheduleTitle;
  }

  @override
  Widget build(BuildContext context) {
    return SchedulePage();
  }

  @override
  String get route => "schedule";
}
