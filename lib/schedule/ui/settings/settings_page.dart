import 'package:dhbwstuttgart/common/ui/viewmodels/root_view_model.dart';
import 'package:dhbwstuttgart/common/ui/widgets/title_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          TitleListTile(title: "Vorlesungsplan"),
          ListTile(
            title: Text("Rapla URL festlegen"),
            onTap: () {},
          ),
          Divider(),
          TitleListTile(title: "Aussehen"),
          PropertyChangeConsumer(
            properties: [
              "isDarkMode",
            ],
            builder:
                (BuildContext context, RootViewModel model, Set properties) {
              return SwitchListTile(
                title: Text("Dark mode"),
                onChanged: model.setIsDarkMode,
                value: model.isDarkMode,
              );
            },
          ),
          Divider(),
          TitleListTile(title: "Über"),
          ListTile(
            title: Text("Über die DHBW App"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationIcon: Icon(Icons.security),
                applicationLegalese: "Designed and developed by Benedikt Kolb",
                applicationName: "DHBW Student App",
                applicationVersion: "v0.0.1",
              );
            },
          ),
          ListTile(
            title: Text("Source code auf GitHub ansehen"),
            onTap: () {
              launch("https://github.com/Bennik2000/DHBWStudentInformationApp");
            },
          ),
          Divider()
        ],
      ),
    );
  }
}
