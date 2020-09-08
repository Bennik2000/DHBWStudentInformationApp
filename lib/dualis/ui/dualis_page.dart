import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/dualis/ui/exam_results_page/exam_results_page.dart';
import 'package:dhbwstudentapp/dualis/ui/login/dualis_login_page.dart';
import 'package:dhbwstudentapp/dualis/ui/study_overview/study_overview_page.dart';
import 'package:dhbwstudentapp/dualis/ui/viewmodels/study_grades_view_model.dart';
import 'package:dhbwstudentapp/ui/pager_widget.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

class DualisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StudyGradesViewModel viewModel = Provider.of<BaseViewModel>(context);

    Widget widget;

    if (viewModel.loginState != LoginState.LoggedIn) {
      widget = DualisLoginPage();
    } else {
      widget = PropertyChangeProvider<StudyGradesViewModel>(
        value: viewModel,
        child: PagerWidget(
          pagesId: "dualis_pager",
          pages: <PageDefinition>[
            PageDefinition(
              text: Text(L.of(context).pageDualisOverview),
              icon: Icon(Icons.dashboard),
              builder: (BuildContext context) => StudyOverviewPage(),
            ),
            PageDefinition(
              text: Text(L.of(context).pageDualisExams),
              icon: Icon(Icons.book),
              builder: (BuildContext context) => ExamResultsPage(),
            ),
          ],
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: widget,
    );
  }
}
