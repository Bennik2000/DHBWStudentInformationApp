import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/dualis/ui/login/dualis_login_page.dart';
import 'package:dhbwstudentapp/dualis/ui/viewmodels/study_grades_view_model.dart';
import 'package:dhbwstudentapp/dualis/ui/widgets/grade_state_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

class ExamResultsPage extends StatelessWidget {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Text(
                    L.of(context).dualisExamResultsTitle,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(L.of(context).dualisExamResultsSemesterSelect),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                        child: PropertyChangeConsumer(
                          properties: [
                            "currentSemesterName",
                            "allSemesterNames",
                          ],
                          builder: (
                            BuildContext context,
                            StudyGradesViewModel model,
                            Set properties,
                          ) =>
                              DropdownButton(
                            onChanged: (value) => model.loadSemester(value),
                            value: model.currentSemesterName,
                            items: (model.allSemesterNames ?? [])
                                .map(
                                  (n) => DropdownMenuItem(
                                    child: Text(n),
                                    value: n,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: PropertyChangeConsumer(
                    properties: ["currentSemester"],
                    builder: (
                      BuildContext context,
                      StudyGradesViewModel model,
                      Set properties,
                    ) =>
                        model.currentSemester != null
                            ? buildDataTable(context, model)
                            : Center(child: CircularProgressIndicator()),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDataTable(BuildContext context, StudyGradesViewModel viewModel) {
    return AnimatedSwitcher(
      layoutBuilder: (Widget currentChild, List<Widget> previousChildren) {
        List<Widget> children = previousChildren;
        if (currentChild != null)
          children = children.toList()..add(currentChild);
        return Stack(
          children: children,
          alignment: Alignment.topCenter,
        );
      },
      child: DataTable(
        key: ValueKey("semester_${viewModel.currentSemester?.name}"),
        columnSpacing: 10,
        dataRowHeight: 60,
        headingRowHeight: 50,
        rows: buildGradesDataRows(context, viewModel),
        columns: buildDataTableColumns(context),
      ),
      duration: Duration(milliseconds: 200),
    );
  }

  List<DataRow> buildGradesDataRows(
      BuildContext context, StudyGradesViewModel viewModel) {
    var dataRows = <DataRow>[];

    for (var module in viewModel.currentSemester.modules) {
      for (var exam in module.exams) {
        dataRows.add(
          DataRow(
            cells: <DataCell>[
              DataCell(Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    module.name,
                  ),
                  Text(
                    exam.name,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              )),
              DataCell(Text(module.credits)),
              DataCell(Text(exam.grade.toString())),
            ],
          ),
        );
      }
    }
    return dataRows;
  }

  List<DataColumn> buildDataTableColumns(BuildContext context) {
    return <DataColumn>[
      DataColumn(
        label: Text(L.of(context).dualisExamResultsExamColumnHeader),
        numeric: false,
      ),
      DataColumn(
        label: Text(L.of(context).dualisExamResultsCreditsColumnHeader),
        numeric: true,
      ),
      DataColumn(
        label: Text(L.of(context).dualisExamResultsGradeColumnHeader),
        numeric: true,
      ),
    ];
  }
}
