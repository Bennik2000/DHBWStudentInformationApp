import 'package:device_calendar/device_calendar.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/date_management/data/calendar_access.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:dhbwstudentapp/date_management/ui/viewmodels/calendar_export_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class CalendarExportPage extends StatefulWidget {
  final List<DateEntry> entriesToExport;

  const CalendarExportPage({Key key, this.entriesToExport}) : super(key: key);

  @override
  _CalendarExportPageState createState() =>
      _CalendarExportPageState(entriesToExport);
}

class _CalendarExportPageState extends State<CalendarExportPage> {
  final List<DateEntry> entriesToExport;
  CalendarExportViewModel viewModel;

  _CalendarExportPageState(this.entriesToExport);

  @override
  void initState() {
    super.initState();

    viewModel = CalendarExportViewModel(
      entriesToExport,
      CalendarAccess(),
    );

    viewModel.setOnPermissionDeniedCallback(() {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          textTheme: Theme.of(context).textTheme,
          actionsIconTheme: Theme.of(context).iconTheme,
          elevation: 0,
          brightness: Theme.of(context).brightness,
          iconTheme: Theme.of(context).iconTheme,
          title: Text(L.of(context).dateManagementExportToCalendar),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      L.of(context).dateManagementExportToCalendarDescription)),
            ),
            _buildCalendarList(),
            const Divider(
              height: 1,
            ),
            _buildExportButton()
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarList() {
    return Expanded(
      child: PropertyChangeConsumer(
        builder: (BuildContext context, CalendarExportViewModel viewModel, _) =>
            ListView.builder(
          itemCount: viewModel.calendars.length,
          itemBuilder: (BuildContext context, int index) {
            var isSelected =
                viewModel.selectedCalendar == viewModel.calendars[index];

            return _buildCalendarListEntry(
              viewModel.calendars[index],
              isSelected,
            );
          },
        ),
      ),
    );
  }

  Widget _buildCalendarListEntry(
    Calendar calendar,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        viewModel.toggleSelection(calendar);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Color(calendar.color) : Colors.transparent,
                border: Border.all(
                  color: Color(calendar.color),
                  width: 4,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Text(calendar.name),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: PropertyChangeConsumer(
          builder:
              (BuildContext context, CalendarExportViewModel viewModel, _) =>
                  viewModel.isExporting
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                              height: 32,
                              width: 32,
                              child: CircularProgressIndicator()),
                        )
                      : FlatButton(
                          textColor: Theme.of(context).accentColor,
                          child: Text(L
                              .of(context)
                              .dateManagementExportToCalendarConfirm
                              .toUpperCase()),
                          onPressed: viewModel.canExport
                              ? () async {
                                  await viewModel.export();
                                  Navigator.of(context).pop();
                                }
                              : null,
                        ),
        ),
      ),
    );
  }
}
