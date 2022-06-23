import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/date_management/model/date_database.dart';
import 'package:dhbwstudentapp/date_management/ui/viewmodels/date_management_view_model.dart';
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
      secondChild: _fixAbsorbPointer(_buildExpanded()),
      firstChild: _fixAbsorbPointer(_buildCollapsed()),
      duration: const Duration(milliseconds: 200),
      crossFadeState:
          _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    );
  }

  Widget _fixAbsorbPointer(Widget widget) {
    // Wrap the widgets in a stack and absorb the pointer
    // Otherwise the hidden widget receives pointing gestures
    // More details here: https://github.com/flutter/flutter/issues/10168
    return Stack(
      children: [
        const Positioned.fill(
          child: AbsorbPointer(),
        ),
        widget
      ],
    );
  }

  Widget _buildCollapsed() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = true;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: _buildCollapsedChips(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: ButtonTheme(
              minWidth: 36,
              height: 36,
              child: IconButton(
                icon: Icon(Icons.tune),
                onPressed: () {
                  setState(() {
                    _isExpanded = true;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedChips() {
    var chips = <Widget>[];

    if (viewModel.showPassedDates && viewModel.showFutureDates) {
      chips.add(Chip(
        label: Text(L.of(context).dateManagementChipFutureAndPast),
        visualDensity: VisualDensity.compact,
      ));
    } else if (viewModel.showFutureDates) {
      chips.add(Chip(
        label: Text(L.of(context).dateManagementChipOnlyFuture),
        visualDensity: VisualDensity.compact,
      ));
    } else if (viewModel.showPassedDates) {
      chips.add(Chip(
        label: Text(L.of(context).dateManagementChipOnlyPassed),
        visualDensity: VisualDensity.compact,
      ));
    }

    if (viewModel.currentSelectedYear != null) {
      chips.add(Chip(
        label: Text(viewModel.currentSelectedYear),
        visualDensity: VisualDensity.compact,
      ));
    }

    var database = viewModel.currentDateDatabase?.displayName ?? "";
    if (database != "") {
      chips.add(Chip(
        label: Text(database),
        visualDensity: VisualDensity.compact,
      ));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Wrap(
        spacing: 8,
        children: chips,
      ),
    );
  }

  Widget _buildExpanded() {
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
                        L.of(context).dateManagementDropDownDatabase,
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
                      items: _buildDatabaseMenuItems(),
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
                      child: Text(
                        L.of(context).dateManagementDropDownYear,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: DropdownButton(
                      isExpanded: true,
                      value: viewModel.currentSelectedYear,
                      onChanged: (value) {
                        viewModel.setCurrentSelectedYear(value);
                      },
                      items: _buildYearsMenuItems(),
                    ),
                  ),
                ],
              ),
              CheckboxListTile(
                title: Text(L.of(context).dateManagementCheckBoxFutureDates),
                value: viewModel.showFutureDates,
                dense: true,
                onChanged: (bool value) {
                  viewModel.setShowFutureDates(value);
                },
              ),
              CheckboxListTile(
                title: Text(L.of(context).dateManagementCheckBoxPassedDates),
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
            child: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                setState(() {
                  _isExpanded = false;
                });

                viewModel.updateDates();
              },
            ),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _buildYearsMenuItems() {
    var yearMenuItems = <DropdownMenuItem<String>>[];

    for (var year in viewModel.years) {
      yearMenuItems.add(DropdownMenuItem(
        child: Text(year),
        value: year,
      ));
    }
    return yearMenuItems;
  }

  List<DropdownMenuItem<DateDatabase>> _buildDatabaseMenuItems() {
    var databaseMenuItems = <DropdownMenuItem<DateDatabase>>[];

    for (var database in viewModel.allDateDatabases) {
      databaseMenuItems.add(DropdownMenuItem(
        child: Text(database.displayName),
        value: database,
      ));
    }
    return databaseMenuItems;
  }
}
