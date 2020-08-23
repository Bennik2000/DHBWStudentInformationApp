import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/common/util/date_utils.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:dhbwstudentapp/date_management/ui/viewmodels/date_management_view_model.dart';
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
              Divider(),
              AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: viewModel.isLoading
                      ? LinearProgressIndicator()
                      : Container()),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: PropertyChangeConsumer(
                builder: (
                  BuildContext context,
                  DateManagementViewModel model,
                  _,
                ) =>
                    AnimatedSwitcher(
                        duration: Duration(milliseconds: 200),
                        child: _buildAllDatesDataTable(model, context)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataTable _buildAllDatesDataTable(
    DateManagementViewModel model,
    BuildContext context,
  ) {
    var dataRows = <DataRow>[];
    for (DateEntry dateEntry in model?.allDates ?? []) {
      dataRows.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text(dateEntry.description)),
            DataCell(Text(dateEntry.year)),
            DataCell(Column(
              children: <Widget>[
                Text(
                  DateFormat.yMd(L.of(context).locale.languageCode)
                      .format(dateEntry.dateAndTime),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                isAtMidnight(dateEntry.dateAndTime)
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                        child: Text(
                          DateFormat.Hm(L.of(context).locale.languageCode)
                              .format(dateEntry.dateAndTime),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
            )),
          ],
        ),
      );
    }

    return DataTable(
      key: ValueKey(model.dateEntriesKeyIndex),
      rows: dataRows,
      columns: <DataColumn>[
        DataColumn(label: Text("Beschreibung")),
        DataColumn(label: Text("Jahrgang")),
        DataColumn(label: Text("Datum")),
      ],
    );
  }
}
