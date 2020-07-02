import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/dualis/ui/login/dualis_login_page.dart';
import 'package:dhbwstudentapp/dualis/ui/viewmodels/study_grades_view_model.dart';
import 'package:dhbwstudentapp/dualis/ui/widgets/grade_state_icon.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

class StudyOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StudyGradesViewModel viewModel = Provider.of<BaseViewModel>(context);

    return PropertyChangeProvider(
      value: viewModel,
      child: DualisLoginPage(
        builder: (BuildContext context) => Container(
          height: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildGpaCredits(context),
                buildModules(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGpaCredits(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            L.of(context).dualisOverviewModuleGrades,
            style: Theme.of(context).textTheme.title,
          ),
          PropertyChangeConsumer(
            properties: ["studyGrades"],
            builder: (
              BuildContext context,
              StudyGradesViewModel model,
              Set properties,
            ) =>
                model.studyGrades != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Row(
                              textBaseline: TextBaseline.alphabetic,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: <Widget>[
                                Text(
                                  model.studyGrades.gpaTotal.toString(),
                                  style: Theme.of(context).textTheme.display2,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                  child: Text(
                                    L.of(context).dualisOverviewGpaTotalModules,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            textBaseline: TextBaseline.alphabetic,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            children: <Widget>[
                              Text(
                                model.studyGrades.gpaMainModules.toString(),
                                style: Theme.of(context).textTheme.display2,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                child: Text(
                                  L.of(context).dualisOverviewGpaMainModules,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Row(
                              textBaseline: TextBaseline.alphabetic,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: <Widget>[
                                Text(
                                  "${model.studyGrades.creditsGained} / ${model.studyGrades.creditsTotal}",
                                  style: Theme.of(context).textTheme.display2,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                  child: Text(
                                    L.of(context).dualisOverviewCredits,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : buildProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Widget buildModules(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Text(
              L.of(context).dualisOverviewModuleGrades,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          PropertyChangeConsumer(
            properties: ["allModules"],
            builder: (
              BuildContext context,
              StudyGradesViewModel model,
              Set properties,
            ) =>
                model.allModules != null
                    ? buildModulesDataTable(context, model)
                    : buildProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Padding buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildModulesDataTable(
    BuildContext context,
    StudyGradesViewModel model,
  ) {
    var dataRows = <DataRow>[];

    for (var module in model.allModules) {
      dataRows.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text(module.name)),
            DataCell(Text(module.credits)),
            DataCell(Text(module.grade)),
            DataCell(GradeStateIcon(state: module.state)),
          ],
        ),
      );
    }

    return DataTable(
      columnSpacing: 10,
      headingRowHeight: 50,
      rows: dataRows,
      columns: buildDataTableColumns(context),
    );
  }

  List<DataColumn> buildDataTableColumns(BuildContext context) {
    return <DataColumn>[
      DataColumn(
        label: Text(L.of(context).dualisOverviewModuleColumnHeader),
        numeric: false,
      ),
      DataColumn(
        label: Text(L.of(context).dualisOverviewCreditsColumnHeader),
        numeric: true,
      ),
      DataColumn(
        label: Text(L.of(context).dualisOverviewGradeColumnHeader),
        numeric: true,
      ),
      DataColumn(
        label: Text(""),
        numeric: true,
        tooltip: L.of(context).dualisOverviewPassedColumnHeader,
      ),
    ];
  }
}
