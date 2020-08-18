import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:dhbwstudentapp/date_management/ui/viewmodels/date_management_view_model.dart';
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("Termindatenbank"),
              DropdownButton(
                items: <DropdownMenuItem<dynamic>>[
                  DropdownMenuItem(
                    child: Text("Termine_Informatik"),
                  )
                ],
                onChanged: (value) {},
              ),
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
                    _buildAllDatesDataTable(model, context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataTable _buildAllDatesDataTable(
      DateManagementViewModel model, BuildContext context) {
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: Text(
                    DateFormat.Hm(L.of(context).locale.languageCode)
                        .format(dateEntry.dateAndTime),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            )),
          ],
        ),
      );
    }

    return DataTable(
      rows: dataRows,
      columns: <DataColumn>[
        DataColumn(label: Text("Beschreibung")),
        DataColumn(label: Text("Jahrgang")),
        DataColumn(label: Text("Datum")),
      ],
    );
  }
}
