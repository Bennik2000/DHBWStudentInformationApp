import 'package:dhbwstudentapp/common/application_constants.dart';
import 'package:dhbwstudentapp/common/background/task_callback.dart';
import 'package:dhbwstudentapp/common/background/work_scheduler_service.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/root_view_model.dart';
import 'package:dhbwstudentapp/common/ui/widgets/title_list_tile.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:dhbwstudentapp/schedule/ui/notification/next_day_information_notification.dart';
import 'package:dhbwstudentapp/schedule/ui/widgets/enter_rapla_url_dialog.dart';
import 'package:dhbwstudentapp/ui/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kiwi/kiwi.dart';

///
/// Widget for the application settings route. Provides access to many settings
/// of the app
///
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsViewModel settingsViewModel = SettingsViewModel(
    KiwiContainer().resolve(),
    KiwiContainer().resolve<TaskCallback>(NextDayInformationNotification.name)
        as NextDayInformationNotification,
  );

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];

    widgets.addAll(buildScheduleSourceSettings(context));
    widgets.addAll(buildDesignSettings(context));
    widgets.addAll(buildNotificationSettings(context));
    widgets.addAll(buildAboutSettings(context));
    widgets.add(buildDisclaimer(context));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        textTheme: Theme.of(context).textTheme,
        actionsIconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        brightness: Theme.of(context).brightness,
        iconTheme: Theme.of(context).iconTheme,
        title: Text(L.of(context).settingsPageTitle),
      ),
      body: PropertyChangeProvider<SettingsViewModel>(
        value: settingsViewModel,
        child: ListView(
          children: widgets,
        ),
      ),
    );
  }

  Widget buildDisclaimer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Text(
        L.of(context).disclaimer,
        style: Theme.of(context).textTheme.overline,
      ),
    );
  }

  List<Widget> buildAboutSettings(BuildContext context) {
    return [
      TitleListTile(title: L.of(context).settingsAboutTitle),
      ListTile(
        title: Text(L.of(context).settingsAbout),
        onTap: () {
          showAboutDialog(
            context: context,
            applicationIcon: Image.asset(
              "assets/app_icon.png",
              width: 75,
            ),
            applicationLegalese: L.of(context).applicationLegalese,
            applicationName: L.of(context).applicationName,
            applicationVersion: ApplicationVersion,
          );
        },
      ),
      ListTile(
        title: Text(L.of(context).settingsViewSourceCode),
        onTap: () {
          launch(ApplicationSourceCodeUrl);
        },
      ),
      const Divider(),
    ];
  }

  List<Widget> buildScheduleSourceSettings(BuildContext context) {
    return [
      TitleListTile(title: L.of(context).settingsScheduleSourceTitle),
      ListTile(
        title: Text(L.of(context).settingsScheduleSourceUrl),
        onTap: () async {
          await EnterRaplaUrlDialog(
            KiwiContainer().resolve(),
            KiwiContainer().resolve(),
          ).show(context);
        },
      ),
      ListTile(
        title: Text("Change to dualis"),
        onTap: () async {
          ScheduleSourceProvider provider = KiwiContainer().resolve();
          await provider.setupForDualis();
        },
      ),
      const Divider(),
    ];
  }

  List<Widget> buildNotificationSettings(BuildContext context) {
    WorkSchedulerService service = KiwiContainer().resolve();
    if (service?.isSchedulingAvailable() ?? false) {
      return [
        TitleListTile(title: L.of(context).settingsNotificationsTitle),
        PropertyChangeConsumer(
          properties: const [
            "notifyAboutNextDay",
          ],
          builder:
              (BuildContext context, SettingsViewModel model, Set properties) {
            return SwitchListTile(
              title: Text(L.of(context).settingsNotificationsNextDay),
              onChanged: model.setNotifyAboutNextDay,
              value: model.notifyAboutNextDay,
            );
          },
        ),
        PropertyChangeConsumer(
          properties: const [
            "notifyAboutScheduleChanges",
          ],
          builder:
              (BuildContext context, SettingsViewModel model, Set properties) {
            return SwitchListTile(
              title: Text(L.of(context).settingsNotificationsScheduleChange),
              onChanged: model.setNotifyAboutScheduleChanges,
              value: model.notifyAboutScheduleChanges,
            );
          },
        ),
        const Divider(),
      ];
    } else {
      return [];
    }
  }

  List<Widget> buildDesignSettings(BuildContext context) {
    return [
      TitleListTile(title: L.of(context).settingsDesign),
      PropertyChangeConsumer(
        properties: const [
          "isDarkMode",
        ],
        builder: (BuildContext context, RootViewModel model, Set properties) {
          return SwitchListTile(
            title: Text(L.of(context).settingsDarkMode),
            onChanged: model.setIsDarkMode,
            value: model.isDarkMode,
          );
        },
      ),
      const Divider(),
    ];
  }
}
