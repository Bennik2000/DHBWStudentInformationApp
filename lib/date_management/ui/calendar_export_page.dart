import 'package:device_calendar/device_calendar.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/colors.dart';
import 'package:dhbwstudentapp/date_management/data/calendar_access.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:dhbwstudentapp/date_management/ui/viewmodels/calendar_export_view_model.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class CalendarExportPage extends StatefulWidget {
  final List<DateEntry> entriesToExport;
  final bool isCalendarSyncWidget;
  final bool isCalendarSyncEnabled;

  const CalendarExportPage(
      {Key? key,
      required this.entriesToExport,
      this.isCalendarSyncWidget = false,
      this.isCalendarSyncEnabled = false,})
      : super(key: key);

  @override
  _CalendarExportPageState createState() => _CalendarExportPageState();
}

class _CalendarExportPageState extends State<CalendarExportPage> {
  late CalendarExportViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = CalendarExportViewModel(widget.entriesToExport,
        CalendarAccess(), KiwiContainer().resolve<PreferencesProvider>(),);
    viewModel.setOnPermissionDeniedCallback(() {
      Navigator.of(context).pop();
    });
    viewModel.loadSelectedCalendar();
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider<CalendarExportViewModel, String>(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actionsIconTheme: Theme.of(context).iconTheme,
          elevation: 0,
          iconTheme: Theme.of(context).iconTheme,
          title: Text(widget.isCalendarSyncWidget
              ? L.of(context).calendarSyncPageTitle
              : L.of(context).dateManagementExportToCalendar,),
          toolbarTextStyle: Theme.of(context).textTheme.bodyText2,
          titleTextStyle: Theme.of(context).textTheme.headline6,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.isCalendarSyncWidget
                    ? L.of(context).calendarSyncPageSubtitle
                    : L.of(context).dateManagementExportToCalendarDescription,),
              ),
            ),
            _buildCalendarList(),
            const Divider(
              height: 1,
            ),
            _buildStopCalendarSyncBtn(),
            _buildExportButton()
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarList() {
    return Expanded(
      child: PropertyChangeConsumer<CalendarExportViewModel, String>(
        builder:
            (BuildContext context, CalendarExportViewModel? viewModel, _) =>
                ListView.builder(
          itemCount: viewModel!.calendars.length,
          itemBuilder: (BuildContext context, int index) {
            final isSelected =
                viewModel.selectedCalendar?.id == viewModel.calendars[index].id;

            return _buildCalendarListEntry(
              viewModel.calendars[index],
              isSelected,
            );
          },
        ),
      ),
    );
  }

  Widget _buildStopCalendarSyncBtn() {
    // Dont display the "Synchronisation beenden" button,
    //if synchronization is not enabled or if it is not the right page
    if (!widget.isCalendarSyncWidget) return const SizedBox();

    return PropertyChangeProvider<CalendarExportViewModel, String>(
      value: viewModel,
      child: Column(
        children: [
          Container(
            decoration: widget.isCalendarSyncEnabled ? null : null,
            child: ListTile(
              enabled: widget.isCalendarSyncEnabled ? true : false,
              title: Text(
                L.of(context).calendarSyncPageEndSync.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: widget.isCalendarSyncEnabled
                        ? ColorPalettes.main
                        : Theme.of(context).disabledColor,
                    fontSize: 14,),
              ),
              onTap: () async {
                KiwiContainer()
                    .resolve<PreferencesProvider>()
                    .setIsCalendarSyncEnabled(false);
                viewModel.resetSelectedCalendar();
                Navigator.of(context).pop();
              },
            ),
          ),
          const Divider(
            height: 1,
          ),
        ],
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
          children: <Widget>[
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Color(calendar.color!) : Colors.transparent,
                border: Border.all(
                  color: Color(calendar.color!),
                  width: 4,
                ),
              ),
              child: isSelected
                  ? const Center(
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
              child: Text(calendar.name!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportButton() {
    return PropertyChangeConsumer<CalendarExportViewModel, String>(
      builder: (BuildContext context, CalendarExportViewModel? viewModel, _) =>
          viewModel!.isExporting
              ? const Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 15),
                  child: SizedBox(
                      height: 32,
                      width: 32,
                      child: CircularProgressIndicator(),),
                )
              : Container(
                  decoration: !viewModel.canExport
                      ? new BoxDecoration(
                          color: Theme.of(context).colorScheme.background,)
                      : new BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: ListTile(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                      title: Text(
                        widget.isCalendarSyncWidget
                            ? L
                                .of(context)
                                .calendarSyncPageBeginSync
                                .toUpperCase()
                            : L
                                .of(context)
                                .dateManagementExportToCalendarConfirm
                                .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      onTap: viewModel.canExport
                          ? () async {
                              if (widget.isCalendarSyncWidget) {
                                final preferencesProvider = KiwiContainer()
                                    .resolve<PreferencesProvider>();
                                preferencesProvider.setSelectedCalendar(
                                    viewModel.selectedCalendar,);
                                preferencesProvider
                                    .setIsCalendarSyncEnabled(true);
                              }
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
