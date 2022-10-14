import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/util/platform_util.dart';
import 'package:dhbwstudentapp/dualis/model/exam_grade.dart';
import 'package:dhbwstudentapp/dualis/model/module.dart';
import 'package:dhbwstudentapp/dualis/ui/viewmodels/study_grades_view_model.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class ExamResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
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
                children: <Widget>[
                  Text(L.of(context).dualisExamResultsSemesterSelect),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                    child: PropertyChangeConsumer(
                      properties: const [
                        "currentSemesterName",
                        "allSemesterNames",
                      ],
                      builder: (
                        BuildContext context,
                        StudyGradesViewModel? model,
                        Set? properties,
                      ) =>
                          DropdownButton(
                        onChanged: model?.loadSemester,
                        value: model?.currentSemesterName,
                        items: model?.allSemesterNames
                            ?.map(
                              (n) => DropdownMenuItem(
                                value: n,
                                child: Text(n),
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
              properties: const ["currentSemester"],
              builder: (
                BuildContext context,
                StudyGradesViewModel? model,
                Set? properties,
              ) =>
                  model!.currentSemester != null
                      ? buildModulesColumn(context, model)
                      : const Padding(
                          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildModulesColumn(
    BuildContext context,
    StudyGradesViewModel viewModel,
  ) {
    return AnimatedSwitcher(
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        List<Widget> children = previousChildren;
        if (currentChild != null) {
          children = children.toList()..add(currentChild);
        }
        return Stack(
          alignment: Alignment.topCenter,
          children: children,
        );
      },
      duration: const Duration(milliseconds: 200),
      child: Column(
        key: ValueKey("semester_${viewModel.currentSemester?.name}"),
        children: buildModulesDataTables(context, viewModel),
      ),
    );
  }

  List<Widget> buildModulesDataTables(
    BuildContext context,
    StudyGradesViewModel viewModel,
  ) {
    final dataTables = <Widget>[];

    var isFirstModule = true;
    for (final module in viewModel.currentSemester!.modules) {
      dataTables.add(
        DataTable(
          horizontalMargin: 24,
          columnSpacing: 0,
          dataRowHeight: 45,
          headingRowHeight: 65,
          rows: buildModuleDataRows(context, module),
          columns: buildModuleColumns(
            context,
            module,
            displayGradeHeader: isFirstModule,
          ),
        ),
      );
      isFirstModule = false;
    }
    return dataTables;
  }

  List<DataRow> buildModuleDataRows(BuildContext context, Module module) {
    final dataRows = <DataRow>[];

    for (final exam in module.exams) {
      dataRows.add(
        DataRow(
          cells: <DataCell>[
            DataCell(
              Column(
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
                    textScaleFactor: exam.semester == "" ? 0 : 1,
                  ),
                ],
              ),
            ),
            DataCell.empty,
            DataCell(
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                child: _examGradeToWidget(context, exam.grade),
              ),
            ),
          ],
        ),
      );
    }
    return dataRows;
  }

  Widget _examGradeToWidget(BuildContext context, ExamGrade grade) {
    switch (grade.state) {
      case ExamGradeState.NotGraded:
        return const Text("");
      case ExamGradeState.Graded:
        return Text(grade.gradeValue!);
      case ExamGradeState.Passed:
        return Text(L.of(context).examPassed);
      case ExamGradeState.Failed:
        return Text(L.of(context).examNotPassed);
    }
  }

  List<DataColumn> buildModuleColumns(
    BuildContext context,
    Module module, {
    bool displayGradeHeader = false,
  }) {
    var displayWidth = MediaQuery.of(context).size.width;

    if (!PlatformUtil.isPortrait(context) && PlatformUtil.isTablet()) {
      print("isTablet");
      displayWidth -= 250;
    }

    return <DataColumn>[
      DataColumn(
        label: ConstrainedBox(
          constraints: BoxConstraints.expand(
            width: displayWidth * 0.5 -
                24, // Subtract the horizontal padding of the DataTable
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 16),
              child: Text(
                module.name ?? "",
                style: Theme.of(context).textTheme.subtitle2,
                softWrap: true,
              ),
            ),
          ),
        ),
      ),
      DataColumn(
        label: ConstrainedBox(
          constraints: BoxConstraints.expand(
            width: displayWidth * 0.25,
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 16),
              child: Text(
                "${L.of(context).dualisExamResultsCreditsColumnHeader}:  ${module.credits}",
              ),
            ),
          ),
        ),
        numeric: true,
      ),
      DataColumn(
        label: ConstrainedBox(
          constraints: BoxConstraints.expand(
            width: displayWidth * 0.25,
          ),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 16),
              child: Text(
                displayGradeHeader
                    ? L.of(context).dualisExamResultsGradeColumnHeader
                    : "",
              ),
            ),
          ),
        ),
        numeric: true,
      ),
    ];
  }
}
