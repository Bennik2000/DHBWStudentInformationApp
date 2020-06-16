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
          _createHeader(),
          _createDrawerItem(
            icon: Icons.calendar_today,
            text: "Vorlesungsplan",
          ),
          _createDrawerItem(
            icon: Icons.dashboard,
            text: "Raumplan",
          ),
          _createDrawerItem(
            icon: Icons.settings,
            text: "Einstellungen",
          ),
          Expanded(
            child: Container(),
          ),
          ListTile(
            title: Text(
              '0.0.1',
              style: Theme.of(context).textTheme.overline,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.red,
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text(
              "DHBW Stuttgart",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem({
    IconData icon,
    String text,
    GestureTapCallback onTap,
  }) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap ?? () {},
    );
  }
}
