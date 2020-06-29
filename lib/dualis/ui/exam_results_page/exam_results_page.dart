import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/dualis/model/exam.dart';
import 'package:dhbwstudentapp/dualis/ui/login/dualis_login_page.dart';
import 'package:dhbwstudentapp/dualis/ui/viewmodels/study_grades_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

class ExamResultsPage extends StatefulWidget {
  @override
  _ExamResultsPageState createState() => _ExamResultsPageState();
}

class _ExamResultsPageState extends State<ExamResultsPage> {
  int currentSemester = 0;

  void semesterDrowDownChanged(int index) {
    setState(() {
      currentSemester = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    StudyGradesViewModel viewModel = Provider.of<BaseViewModel>(context);

    var semestersDropDownMenuItems = <DropdownMenuItem>[];

    int i = 0;
    for (var semester in viewModel.studyGrades.semesters) {
      semestersDropDownMenuItems.add(
        DropdownMenuItem(
          child: Text(semester.name),
          value: i++,
        ),
      );
    }

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
                    "Prüfungsergebnisse",
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Semester"),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                        child: DropdownButton(
                          onChanged: (value) => semesterDrowDownChanged(value),
                          value: currentSemester,
                          items: semestersDropDownMenuItems,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: buildDataTable(viewModel),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDataTable(StudyGradesViewModel viewModel) {
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
        key: ValueKey("semester_$currentSemester"),
        columnSpacing: 10,
        headingRowHeight: 50,
        rows: buildGradesDataRows(viewModel),
        columns: buildDataTableColumns(),
      ),
      duration: Duration(milliseconds: 200),
    );
  }

  List<DataRow> buildGradesDataRows(StudyGradesViewModel viewModel) {
    var dataRows = <DataRow>[];

    for (var module
        in viewModel.studyGrades.semesters[currentSemester].modules) {
      for (var exam in module.exams) {
        DataCell iconCell;

        switch (exam.state) {
          case ExamState.Passed:
            iconCell = DataCell(Icon(Icons.check, color: Colors.green));
            break;
          case ExamState.Failed:
            iconCell = DataCell(Icon(Icons.close, color: Colors.red));
            break;
          case ExamState.Pending:
            iconCell = DataCell.empty;
            break;
        }

        dataRows.add(
          DataRow(
            cells: <DataCell>[
              DataCell(Text("${module.name} - ${exam.name}")),
              DataCell(Text(module.credits)),
              DataCell(Text(exam.grade.toString())),
              iconCell,
            ],
          ),
        );
      }
    }
    return dataRows;
  }

  List<DataColumn> buildDataTableColumns() {
    return <DataColumn>[
      DataColumn(
        label: Text("Klausur"),
        numeric: false,
      ),
      DataColumn(
        label: Text("Credits"),
        numeric: true,
      ),
      DataColumn(
        label: Text("Note"),
        numeric: true,
      ),
      DataColumn(
        label: Container(),
        numeric: true,
        tooltip: "Bestanden",
      ),
    ];
  }
}
