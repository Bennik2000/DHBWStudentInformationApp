import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/dualis/ui/viewmodels/study_grades_view_model.dart';
import 'package:dhbwstudentapp/dualis/ui/widgets/grade_state_icon.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class StudyOverviewPage extends StatelessWidget {
  const StudyOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildGpaCredits(context),
            buildModules(context),
          ],
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
            L.of(context).dualisOverview,
            style: Theme.of(context).textTheme.headline6,
          ),
          PropertyChangeConsumer(
            properties: const ["studyGrades"],
            builder: (
              BuildContext context,
              StudyGradesViewModel? model,
              Set? properties,
            ) =>
                model?.studyGrades != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Row(
                              textBaseline: TextBaseline.alphabetic,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: <Widget>[
                                Text(
                                  model!.studyGrades!.gpaTotal.toString(),
                                  style: Theme.of(context).textTheme.headline3,
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
                                model.studyGrades!.gpaMainModules.toString(),
                                style: Theme.of(context).textTheme.headline3,
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
                                  "${model.studyGrades!.creditsGained} / ${model.studyGrades!.creditsTotal}",
                                  style: Theme.of(context).textTheme.headline3,
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
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          PropertyChangeConsumer(
            properties: const ["allModules"],
            builder: (
              BuildContext context,
              StudyGradesViewModel? model,
              Set? properties,
            ) =>
                model?.allModules != null
                    ? buildModulesDataTable(context, model!)
                    : buildProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Padding buildProgressIndicator() {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildModulesDataTable(
    BuildContext context,
    StudyGradesViewModel model,
  ) {
    final dataRows = <DataRow>[];

    for (final module in model.allModules!) {
      dataRows.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text(module.name!)),
            DataCell(Text(module.credits!)),
            DataCell(Text(module.grade!)),
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
        label: const Text(""),
        numeric: true,
        tooltip: L.of(context).dualisOverviewPassedColumnHeader,
      ),
    ];
  }
}
