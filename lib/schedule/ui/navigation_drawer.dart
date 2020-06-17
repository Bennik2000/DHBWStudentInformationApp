import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _createHeader(context),
          _createDrawerItem(
            context,
            icon: Icons.calendar_today,
            text: "Vorlesungsplan",
            isSelected: true,
          ),
          _createDrawerItem(
            context,
            icon: Icons.info_outline,
            text: "Nützliche Infos",
          ),
          _createDrawerItem(
            context,
            icon: Icons.data_usage,
            text: "Dualis",
          ),
          _createDrawerItem(
            context,
            icon: Icons.business,
            text: "Bibliothek",
          ),
          _createDrawerItem(
            context,
            icon: Icons.settings,
            text: "Einstellungen",
          )
        ],
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "DHBW Studenten App",
              style: Theme.of(context).textTheme.headline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem(BuildContext context,
      {IconData icon, String text, GestureTapCallback onTap, bool isSelected}) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 0),
      title: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ?? false
              ? Theme.of(context).focusColor
              : Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(icon),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: Text(text),
              ),
            ],
          ),
        ),
      ),
      onTap: onTap ?? () {},
    );
  }
}
