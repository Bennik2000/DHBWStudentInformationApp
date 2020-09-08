import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/date_management/ui/calendar_export_page.dart';
import 'package:dhbwstudentapp/date_management/ui/date_management_page.dart';
import 'package:dhbwstudentapp/date_management/ui/viewmodels/date_management_view_model.dart';
import 'package:dhbwstudentapp/date_management/ui/widgets/date_management_help_dialog.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:dhbwstudentapp/ui/navigation/navigator_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:kiwi/kiwi.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class DateManagementNavigationEntry extends NavigationEntry {
  DateManagementViewModel _viewModel;

  @override
  Widget icon(BuildContext context) {
    return Icon(Icons.date_range);
  }

  @override
  String title(BuildContext context) {
    return L.of(context).pageDateManagementTitle;
  }

  @override
  BaseViewModel initViewModel() {
    if (_viewModel == null) {
      _viewModel = DateManagementViewModel(
        KiwiContainer().resolve(),
        KiwiContainer().resolve(),
      );
    }

    return _viewModel;
  }

  @override
  List<Widget> appBarActions(BuildContext context) {
    initViewModel();
    return [
      IconButton(
        icon: Icon(Icons.help_outline),
        onPressed: () async {
          await DateManagementHelpDialog().show(context);
        },
        tooltip: L.of(context).helpButtonTooltip,
      ),
      PropertyChangeProvider(
        value: _viewModel,
        child: PropertyChangeConsumer(
          builder:
              (BuildContext context, DateManagementViewModel viewModel, _) =>
                  PopupMenuButton<String>(
            onSelected: (i) async {
              await NavigatorKey.rootKey.currentState.push(MaterialPageRoute(
                builder: (BuildContext context) => CalendarExportPage(
                  entriesToExport: viewModel.allDates,
                ),
              ));
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: "",
                  child: Text(L.of(context).dateManagementExportToCalendar),
                )
              ];
            },
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(body: DateManagementPage());
  }

  @override
  String get route => "date_management";
}
