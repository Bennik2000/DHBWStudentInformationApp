import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/dualis/ui/viewmodels/study_grades_view_model.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class ExamResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                style: Theme.of(context).textTheme.headline6,
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
            PropertyChangeConsumer(
                properties: ["currentSemester"],
                builder: (
                  BuildContext context,
                  StudyGradesViewModel model,
                  Set properties,
                ) =>
                    model.currentSemester != null
                        ? buildModulesColumn(context, model)
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildModulesColumn(BuildContext context, StudyGradesViewModel viewModel) {
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
      child: Column(
        key: ValueKey("semester_${viewModel.currentSemester?.name}"),
        children: buildModulesDataTables(context, viewModel),
      ),
      duration: Duration(milliseconds: 200),
    );
  }

  List<DataTable> buildModulesDataTables(
      BuildContext context, StudyGradesViewModel viewModel) {
    var dataTables = <DataTable>[];

    for(var module in viewModel.currentSemester.modules) {
      dataTables.add(
        DataTable(
          columnSpacing: 10,
          dataRowHeight: 45,
          headingRowHeight: 50,
          rows: buildModuleDataRows(context, module),
          columns: buildModuleColumns(context, module),
        )
      );
    }
    return dataTables;
  }

  List<DataRow> buildModuleDataRows(BuildContext context, var module) {
    var dataRows = <DataRow>[];

    for (var exam in module.exams) {
      dataRows.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  exam.name ?? "",
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  exam.semester ?? "",
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
    return dataRows;
  }

  List<DataColumn> buildModuleColumns(
      BuildContext context, var module) {
    return <DataColumn>[
      DataColumn(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Text(
                module.name ?? "",
                style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        numeric: false,
      ),
      DataColumn(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Text(L.of(context).dualisExamResultsCreditsColumnHeader),
        ),
        numeric: true,
      ),
      DataColumn(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Text(L.of(context).dualisExamResultsGradeColumnHeader),
        ),
        numeric: true,
      ),
    ];
  }
}

