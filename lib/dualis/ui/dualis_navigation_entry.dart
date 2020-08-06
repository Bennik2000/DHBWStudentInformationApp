import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/dualis/ui/dualis_page.dart';
import 'package:dhbwstudentapp/dualis/ui/viewmodels/study_grades_view_model.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class DualisNavigationEntry extends NavigationEntry {
  @override
  Widget icon(BuildContext context) {
    return Icon(Icons.data_usage);
  }

  @override
  String title(BuildContext context) {
    return L.of(context).screenDualisTitle;
  }

  @override
  BaseViewModel initViewModel() {
    return StudyGradesViewModel(
      KiwiContainer().resolve(),
      KiwiContainer().resolve(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DualisPage();
  }

  @override
  String get route => "dualis";
}
