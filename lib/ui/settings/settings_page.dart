import 'package:dhbwstudentapp/assets.dart';
import 'package:dhbwstudentapp/common/application_constants.dart';
import 'package:dhbwstudentapp/common/background/task_callback.dart';
import 'package:dhbwstudentapp/common/background/work_scheduler_service.dart';
import 'package:dhbwstudentapp/common/data/preferences/app_theme_enum.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/root_view_model.dart';
import 'package:dhbwstudentapp/common/ui/widgets/title_list_tile.dart';
import 'package:dhbwstudentapp/date_management/data/calendar_access.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:dhbwstudentapp/date_management/ui/calendar_export_page.dart';
import 'package:dhbwstudentapp/schedule/background/calendar_synchronizer.dart';
import 'package:dhbwstudentapp/schedule/ui/notification/next_day_information_notification.dart';
import 'package:dhbwstudentapp/schedule/ui/widgets/select_source_dialog.dart';
import 'package:dhbwstudentapp/ui/navigation/navigator_key.dart';
import 'package:dhbwstudentapp/ui/settings/donate_list_tile.dart';
import 'package:dhbwstudentapp/ui/settings/purchase_widget_list_tile.dart';
import 'package:dhbwstudentapp/ui/settings/select_theme_dialog.dart';
import 'package:dhbwstudentapp/ui/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO: Cleanup ui generation code for the in app purchases
// TODO: Show a loading indicator and error messages right when the purchase button was pressed

///
/// Widget for the application settings route. Provides access to many settings
/// of the app
///
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsViewModel settingsViewModel = SettingsViewModel(
    KiwiContainer().resolve(),
    KiwiContainer().resolve<TaskCallback>(NextDayInformationNotification.name)
        as NextDayInformationNotification,
    KiwiContainer().resolve(),
    KiwiContainer().resolve(),
  );

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];

    widgets.addAll(buildScheduleSourceSettings(context));
    widgets.addAll(buildDesignSettings(context));
    widgets.addAll(buildNotificationSettings(context));
    widgets.addAll(buildAboutSettings(context));
    widgets.add(buildDisclaimer(context));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actionsIconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
        title: Text(L.of(context).settingsPageTitle),
        toolbarTextStyle: Theme.of(context).textTheme.bodyText2,
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ),
      body: PropertyChangeProvider<SettingsViewModel, String>(
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
      const PurchaseWidgetListTile(),
      const DonateListTile(),
      ListTile(
        title: Text(L.of(context).settingsAbout),
        onTap: () {
          showAboutDialog(
            context: context,
            applicationIcon: Image.asset(
              Assets.assets_app_icon_png,
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
          launchUrl(Uri.parse(ApplicationSourceCodeUrl));
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
            (BuildContext context, SettingsViewModel? model, Set? properties) {
          return SwitchListTile(
            title: Text(L.of(context).settingsPrettifySchedule),
            onChanged: model!.setPrettifySchedule,
            value: model.prettifySchedule,
          );
        },
      ),
      ListTile(
        title: Text(L.of(context).settingsCalendarSync),
        onTap: () async {
          if (await CalendarAccess().requestCalendarPermission() ==
              CalendarPermission.PermissionDenied) {
            await showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(
                  L.of(context).dialogTitleCalendarAccessNotGranted,
                ),
                content: Text(L.of(context).dialogCalendarAccessNotGranted),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(L.of(context).dialogOk),
                  )
                ],
              ),
            );
            return;
          }
          final isCalendarSyncEnabled = await KiwiContainer()
              .resolve<PreferencesProvider>()
              .isCalendarSyncEnabled();
          final List<DateEntry> entriesToExport =
              KiwiContainer().resolve<ListDateEntries30d>().listDateEntries;
          await NavigatorKey.rootKey.currentState!.push(
            MaterialPageRoute(
              builder: (BuildContext context) => CalendarExportPage(
                entriesToExport: entriesToExport,
                isCalendarSyncWidget: true,
                isCalendarSyncEnabled: isCalendarSyncEnabled,
              ),
              settings: const RouteSettings(name: "settings"),
            ),
          );
        },
      ),
      const Divider(),
    ];
  }

  List<Widget> buildNotificationSettings(BuildContext context) {
    final WorkSchedulerService service = KiwiContainer().resolve();
    if (service.isSchedulingAvailable()) {
      return [
        TitleListTile(title: L.of(context).settingsNotificationsTitle),
        PropertyChangeConsumer(
          properties: const [
            "notifyAboutNextDay",
          ],
          builder: (
            BuildContext context,
            SettingsViewModel? model,
            Set? properties,
          ) {
            return SwitchListTile(
              title: Text(L.of(context).settingsNotificationsNextDay),
              onChanged: model!.setNotifyAboutNextDay,
              value: model.notifyAboutNextDay,
            );
          },
        ),
        PropertyChangeConsumer(
          properties: const [
            "notifyAboutScheduleChanges",
          ],
          builder: (
            BuildContext context,
            SettingsViewModel? model,
            Set? properties,
          ) {
            return SwitchListTile(
              title: Text(L.of(context).settingsNotificationsScheduleChange),
              onChanged: model!.setNotifyAboutScheduleChanges,
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
          "appTheme",
        ],
        builder: (BuildContext context, RootViewModel? model, Set? properties) {
          return ListTile(
            title: Text(L.of(context).settingsDarkMode),
            onTap: () async {
              await SelectThemeDialog(model!).show(context);
            },
            subtitle: Text(
              {
                AppTheme.Dark: L.of(context).selectThemeDark,
                AppTheme.Light: L.of(context).selectThemeLight,
                AppTheme.System: L.of(context).selectThemeSystem,
              }[model!.appTheme]!,
            ),
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
