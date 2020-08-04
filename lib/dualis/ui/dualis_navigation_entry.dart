import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/dualis/ui/exam_results_page/exam_results_page.dart';
import 'package:dhbwstudentapp/dualis/ui/study_overview/study_overview_page.dart';
import 'package:dhbwstudentapp/dualis/ui/viewmodels/study_grades_view_model.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:dhbwstudentapp/ui/navigation/pageable_navigation_entry.dart';
import 'package:dhbwstudentapp/ui/navigation/single_navigation_entry.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class DualisNavigationEntry extends PageableNavigationEntry {
  @override
  Widget icon(BuildContext context) {
    return Icon(Icons.data_usage);
  }

  @override
  List<NavigationEntry> initPages() {
    return <NavigationEntry>[
      FixedSingleNavigationEntry(
        builder: (_) => StudyOverviewPage(),
        titleBuilder: (BuildContext context) =>
            L.of(context).pageDualisOverview,
        pageKey: Key("StudyOverview"),
        iconBuilder: (_) => Icon(Icons.dashboard),
      ),
      FixedSingleNavigationEntry(
        builder: (_) => ExamResultsPage(),
        titleBuilder: (BuildContext context) => L.of(context).pageDualisExams,
        pageKey: Key("Exams"),
        iconBuilder: (_) => Icon(Icons.book),
      ),
    ];
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
}
