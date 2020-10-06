import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/schedule/ui/schedule_page.dart';
import 'package:dhbwstudentapp/schedule/ui/viewmodels/schedule_view_model.dart';
import 'package:dhbwstudentapp/schedule/ui/widgets/schedule_help_dialog.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class ScheduleNavigationEntry extends NavigationEntry {
  ScheduleViewModel _viewModel;

  @override
  Widget icon(BuildContext context) {
    return Icon(Icons.calendar_today);
  }

  @override
  BaseViewModel initViewModel() {
    if (_viewModel != null) return _viewModel;

    _viewModel = ScheduleViewModel(
      KiwiContainer().resolve(),
    );

    return _viewModel;
  }

  @override
  String title(BuildContext context) {
    return L.of(context).screenScheduleTitle;
  }

  @override
  Widget build(BuildContext context) {
    return SchedulePage();
  }

  @override
  List<Widget> appBarActions(BuildContext context) {
    initViewModel();
    return [
      PropertyChangeProvider(
        value: _viewModel,
        child: PropertyChangeConsumer(
            properties: const ["didSetupProperly"],
            builder: (BuildContext _, ScheduleViewModel __, Set<Object> ___) =>
                _viewModel.didSetupProperly
                    ? Container()
                    : IconButton(
                        icon: Icon(Icons.help_outline),
                        onPressed: () async {
                          await ScheduleHelpDialog().show(context);
                        },
                        tooltip: L.of(context).helpButtonTooltip,
                      )),
      ),
    ];
  }

  @override
  String get route => "schedule";
}
