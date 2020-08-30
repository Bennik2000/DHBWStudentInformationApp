import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/date_management/ui/date_management_page.dart';
import 'package:dhbwstudentapp/date_management/ui/viewmodels/date_management_view_model.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class DateManagementNavigationEntry extends NavigationEntry {
  @override
  Widget icon(BuildContext context) {
    return Icon(Icons.date_range);
  }

  @override
  String title(BuildContext context) {
    return "Terminverwaltung";
  }

  @override
  BaseViewModel initViewModel() {
    return DateManagementViewModel(
      KiwiContainer().resolve(),
      KiwiContainer().resolve(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DateManagementPage();
  }

  @override
  String get route => "date_management";
}
