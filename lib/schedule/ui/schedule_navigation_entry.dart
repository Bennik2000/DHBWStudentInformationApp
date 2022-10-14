import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/schedule/ui/schedule_page.dart';
import 'package:dhbwstudentapp/schedule/ui/viewmodels/schedule_view_model.dart';
import 'package:dhbwstudentapp/schedule/ui/weeklyschedule/filter/schedule_filter_page.dart';
import 'package:dhbwstudentapp/schedule/ui/widgets/schedule_help_dialog.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class ScheduleNavigationEntry extends NavigationEntry<ScheduleViewModel> {
  @override
  Icon icon = const Icon(Icons.calendar_today);

  @override
  ScheduleViewModel initViewModel() {
    return ScheduleViewModel(
      KiwiContainer().resolve(),
    );
  }

  @override
  String title(BuildContext context) {
    return L.of(context).screenScheduleTitle;
  }

  @override
  Widget build(BuildContext context) {
    return const SchedulePage();
  }

  @override
  List<Widget> appBarActions(BuildContext context) {
    return [
      PropertyChangeProvider<ScheduleViewModel, String>(
        value: model,
        child: PropertyChangeConsumer(
            properties: const ["didSetupProperly"],
            builder:
                (BuildContext _, ScheduleViewModel? __, Set<Object>? ___) =>
                    model.didSetupProperly
                        ? Container()
                        : IconButton(
                            icon: const Icon(Icons.help_outline),
                            onPressed: () async {
                              await ScheduleHelpDialog().show(context);
                            },
                            tooltip: L.of(context).helpButtonTooltip,
                          ),),
      ),
      PropertyChangeProvider<ScheduleViewModel, String>(
        value: model,
        child: PropertyChangeConsumer(
          properties: const ["didSetupProperly"],
          builder: (BuildContext _, ScheduleViewModel? __, Set<Object>? ___) =>
              model.didSetupProperly
                  ? IconButton(
                      icon: const Icon(Icons.filter_alt),
                      onPressed: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ScheduleFilterPage(),
                        ),);
                      },
                    )
                  : Container(),
        ),
      )
    ];
  }

  @override
  String get route => "schedule";
}
