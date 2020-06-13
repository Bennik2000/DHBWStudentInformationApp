import 'package:dhbwstuttgart/common/application_constants.dart';
import 'package:dhbwstuttgart/common/i18n/localizations.dart';
import 'package:dhbwstuttgart/common/ui/viewmodels/root_view_model.dart';
import 'package:dhbwstuttgart/common/ui/widgets/title_list_tile.dart';
import 'package:dhbwstuttgart/schedule/ui/onboarding/onboarding_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        children: <Widget>[
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
          TitleListTile(title: L.of(context).settingsDesign),
          PropertyChangeConsumer(
            properties: [
              "isDarkMode",
            ],
            builder:
                (BuildContext context, RootViewModel model, Set properties) {
              return SwitchListTile(
                title: Text(L.of(context).settingsDarkMode),
                onChanged: model.setIsDarkMode,
                value: model.isDarkMode,
              );
            },
          ),
          Divider(),
          TitleListTile(title: L.of(context).settingsAboutTitle),
          ListTile(
            title: Text(L.of(context).settingsAbout),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationIcon: Icon(Icons.security),
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
          Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              L.of(context).disclaimer,
              style: Theme.of(context).textTheme.overline,
            ),
          )
        ],
      ),
    );
  }
}
