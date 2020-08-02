import 'package:dhbwstudentapp/common/application_constants.dart';
import 'package:dhbwstudentapp/common/background/task_callback.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/root_view_model.dart';
import 'package:dhbwstudentapp/common/ui/widgets/title_list_tile.dart';
import 'package:dhbwstudentapp/schedule/ui/notification/next_day_information_notification.dart';
import 'package:dhbwstudentapp/ui/onboarding/onboarding_page.dart';
import 'package:dhbwstudentapp/ui/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kiwi/kiwi.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsViewModel settingsViewModel = SettingsViewModel(
    KiwiContainer().resolve(),
    KiwiContainer().resolve<TaskCallback>(NextDayInformationNotification.name),
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
      Divider(),
    ];
  }

  List<Widget> buildScheduleSourceSettings(BuildContext context) {
    return [
      TitleListTile(title: L.of(context).settingsScheduleSourceTitle),
      ListTile(
        title: Text(L.of(context).settingsScheduleSourceUrl),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => OnboardingPage(),
            ),
          );
        },
      ),
      Divider(),
    ];
  }

  List<Widget> buildNotificationSettings(BuildContext context) {
    return [
      TitleListTile(title: L.of(context).settingsNotificationsTitle),
      PropertyChangeConsumer(
        properties: [
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
        properties: [
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
      Divider(),
    ];
  }

  List<Widget> buildDesignSettings(BuildContext context) {
    return [
      TitleListTile(title: L.of(context).settingsDesign),
      PropertyChangeConsumer(
        properties: [
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
      Divider(),
    ];
  }
}
