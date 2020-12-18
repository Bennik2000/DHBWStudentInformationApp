import 'package:dhbwstudentapp/common/application_constants.dart';
import 'package:dhbwstudentapp/common/background/task_callback.dart';
import 'package:dhbwstudentapp/common/background/work_scheduler_service.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/iap/in_app_purchase_manager.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/root_view_model.dart';
import 'package:dhbwstudentapp/common/ui/widgets/title_list_tile.dart';
import 'package:dhbwstudentapp/schedule/ui/notification/next_day_information_notification.dart';
import 'package:dhbwstudentapp/schedule/ui/widgets/select_source_dialog.dart';
import 'package:dhbwstudentapp/ui/settings/select_theme_dialog.dart';
import 'package:dhbwstudentapp/ui/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

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
    KiwiContainer().resolve(),
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
      PropertyChangeConsumer(
        properties: const [
          "didPurchaseWidget",
        ],
        builder:
            (BuildContext context, SettingsViewModel model, Set properties) {
          return ListTile(
            title: Text(L.of(context).settingsWidgetPurchase),
            trailing: Icon(Icons.widgets_outlined),
            subtitle: model.didPurchaseWidget
                ? Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 16,
                        ),
                      ),
                      Text(
                        L.of(context).settingsWidgetDidPurchase,
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  )
                : null,
            onTap: () async {
              await model.purchaseWidgets();
            },
          );
        },
      ),
      ListTile(
        title: Text(L.of(context).donateButtonTitle),
        subtitle: Text(L.of(context).donateButtonSubtitle),
        trailing: Icon(Icons.free_breakfast),
        onTap: () async {
          await KiwiContainer().resolve<InAppPurchaseManager>().donate();
        },
      ),
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
        title: Text(L.of(context).settingsSetupScheduleSource),
        onTap: () async {
          await SelectSourceDialog(
            KiwiContainer().resolve(),
            KiwiContainer().resolve(),
          ).show(context);
        },
      ),
      PropertyChangeConsumer(
        properties: const [
          "prettifySchedule",
        ],
        builder:
            (BuildContext context, SettingsViewModel model, Set properties) {
          return SwitchListTile(
            title: Text(L.of(context).settingsPrettifySchedule),
            onChanged: model.setPrettifySchedule,
            value: model.prettifySchedule,
          );
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
          return ListTile(
            title: Text(L.of(context).settingsDarkMode),
            onTap: () async {
              await SelectThemeDialog(model).show(context);
            },
            subtitle: Text({
              true: L.of(context).selectThemeDark,
              false: L.of(context).selectThemeLight,
              null: L.of(context).selectThemeSystem,
            }[model.isDarkMode]),
          );
        },
      ),
      const Divider(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    settingsViewModel.dispose();
  }
}
