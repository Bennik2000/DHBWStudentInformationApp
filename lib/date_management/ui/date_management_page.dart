import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/common/ui/widgets/error_display.dart';
import 'package:dhbwstudentapp/common/util/date_utils.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:dhbwstudentapp/date_management/ui/viewmodels/date_management_view_model.dart';
import 'package:dhbwstudentapp/date_management/ui/widgets/date_detail_bottom_sheet.dart';
import 'package:dhbwstudentapp/date_management/ui/widgets/date_filter_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

class DateManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateManagementViewModel viewModel = Provider.of<BaseViewModel>(context);

    return PropertyChangeProvider<DateManagementViewModel>(
      value: viewModel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DateFilterOptions(viewModel: viewModel),
          Stack(
            children: <Widget>[
              const Divider(),
              AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: viewModel.isLoading
                      ? const LinearProgressIndicator()
                      : Container()),
            ],
          ),
          _buildBody(viewModel, context),
        ],
      ),
    );
  }

  Expanded _buildBody(DateManagementViewModel viewModel, BuildContext context) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: PropertyChangeConsumer(
              builder: (
                BuildContext context,
                DateManagementViewModel model,
                _,
              ) =>
                  AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Column(
                        key: ValueKey(
                            viewModel?.dateSearchParameters?.toString() ?? ""),
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          _buildAllDatesDataTable(model, context),
                        ],
                      )),
            ),
          ),
          Align(
            child: buildErrorDisplay(context),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }

  Widget _buildAllDatesDataTable(
    DateManagementViewModel model,
    BuildContext context,
  ) {
    return DataTable(
      key: ValueKey(model.dateEntriesKeyIndex),
      rows: _buildDataTableRows(model, context),
      columns: <DataColumn>[
        DataColumn(
          label: Text(L.of(context).dateManagementTableHeaderDescription),
        ),
        DataColumn(
          label: Text(L.of(context).dateManagementTableHeaderDate),
        ),
      ],
    );
  }

  List<DataRow> _buildDataTableRows(
    DateManagementViewModel model,
    BuildContext context,
  ) {
    var dataRows = <DataRow>[];
    for (DateEntry dateEntry in model?.allDates ?? []) {
      dataRows.add(
        DataRow(
          cells: <DataCell>[
            DataCell(
                Text(dateEntry.description,
                    style: dateEntry.dateAndTime.isBefore(DateTime.now())
                        ? TextStyle(decoration: TextDecoration.lineThrough)
                        : null), onTap: () {
              showDateEntryDetailBottomSheet(context, dateEntry);
            }),
            DataCell(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      DateFormat.yMd(L.of(context).locale.languageCode)
                          .format(dateEntry.dateAndTime),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    // When the date entry has a time of 00:00 don't show it.
                    // It means the date entry is for the whole day
                    isAtMidnight(dateEntry.dateAndTime)
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                            child: Text(
                              DateFormat.Hm(L.of(context).locale.languageCode)
                                  .format(dateEntry.dateAndTime),
                            ),
                          ),
                  ],
                ), onTap: () {
              showDateEntryDetailBottomSheet(context, dateEntry);
            }),
          ],
        ),
      );
    }

    return dataRows;
  }

  void showDateEntryDetailBottomSheet(BuildContext context, DateEntry entry) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (context) => DateDetailBottomSheet(
        dateEntry: entry,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
    );
  }

  Widget buildErrorDisplay(BuildContext context) {
    return PropertyChangeConsumer(
      properties: const [
        "updateFailed",
      ],
      builder: (BuildContext context, DateManagementViewModel model,
              Set properties) =>
          ErrorDisplay(
        show: model.updateFailed,
      ),
    );
  }
}
