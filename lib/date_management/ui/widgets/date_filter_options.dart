import 'package:dhbwstudentapp/date_management/model/date_database.dart';
import 'package:dhbwstudentapp/date_management/ui/viewmodels/date_management_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateFilterOptions extends StatefulWidget {
  final DateManagementViewModel viewModel;

  const DateFilterOptions({Key key, this.viewModel}) : super(key: key);

  @override
  _DateFilterOptionsState createState() => _DateFilterOptionsState(viewModel);
}

class _DateFilterOptionsState extends State<DateFilterOptions> {
  final DateManagementViewModel viewModel;

  bool _isExpanded = false;

  _DateFilterOptionsState(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      secondChild: _buildExpanded(),
      firstChild: _buildCollapsed(),
      duration: Duration(milliseconds: 200),
      crossFadeState:
          _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    );
  }

  Widget _buildCollapsed() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: _buildCollapsedChips(),
        ),
        Expanded(
          child: Container(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
          child: ButtonTheme(
            minWidth: 36,
            height: 36,
            child: FlatButton(
              child: Icon(Icons.tune),
              padding: EdgeInsets.all(0),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                setState(() {
                  _isExpanded = true;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCollapsedChips() {
    var chips = <Widget>[];

    if (viewModel.showFutureDates) {
      chips.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Chip(
          label: Text("Nur Zukünftige"),
        ),
      ));
    }

    if (viewModel.showPassedDates) {
      chips.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Chip(
          label: Text("Nur Vergangene"),
        ),
      ));
    }

    var database = viewModel.currentDateDatabase?.displayName ?? "";
    if (database != "") {
      chips.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Chip(
          label: Text(database),
        ),
      ));
    }

    return chips;
  }

  Widget _buildExpanded() {
    var databaseMenuItems = <DropdownMenuItem<DateDatabase>>[];

    for (var database in viewModel.allDateDatabases) {
      databaseMenuItems.add(DropdownMenuItem(
        child: Text(database.displayName),
        value: database,
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Text(
                        "Termindatenbank:",
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: DropdownButton(
                      isExpanded: true,
                      value: viewModel.currentDateDatabase,
                      onChanged: (value) {
                        viewModel.setCurrentDateDatabase(value);
                      },
                      items: databaseMenuItems,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Text("Jahrgang:"),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: DropdownButton(
                      isExpanded: true,
                      onChanged: (value) {},
                      items: <DropdownMenuItem<dynamic>>[
                        DropdownMenuItem(child: Text("2022")),
                        DropdownMenuItem(child: Text("2021")),
                        DropdownMenuItem(child: Text("2020")),
                        DropdownMenuItem(child: Text("2019")),
                      ],
                    ),
                  ),
                ],
              ),
              CheckboxListTile(
                title: Text("Zukünftige"),
                value: viewModel.showFutureDates,
                dense: true,
                onChanged: (bool value) {
                  viewModel.setShowFutureDates(value);
                },
              ),
              CheckboxListTile(
                title: Text("Vergangene"),
                value: viewModel.showPassedDates,
                dense: true,
                onChanged: (bool value) {
                  viewModel.setShowPassedDates(value);
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 16, 8),
          child: ButtonTheme(
            minWidth: 36,
            height: 36,
            child: FlatButton(
              child: Icon(Icons.check),
              padding: EdgeInsets.all(0),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                setState(() {
                  _isExpanded = false;
                  viewModel.updateDates();
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
