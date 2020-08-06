import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef NavigationItemOnTap = Function(int index);

class NavigationDrawer extends StatelessWidget {
  final int selectedIndex;
  final NavigationItemOnTap onTap;
  final List<DrawerNavigationEntry> entries;

  const NavigationDrawer(
      {Key key, this.selectedIndex, this.onTap, this.entries})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(_createHeader(context));

    int i = 0;
    for (var entry in entries) {
      widgets.add(_createDrawerItem(context,
          icon: entry.icon,
          text: entry.title,
          index: i,
          isSelected: i == selectedIndex));

      i++;
    }

    widgets.add(_createSettingsItem(context));

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widgets,
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
              L.of(context).applicationName,
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem(
    BuildContext context, {
    Widget icon,
    String text,
    bool isSelected,
    int index,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Card(
        color: isSelected ? Theme.of(context).focusColor : Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          child: Container(
            height: 48,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  icon,
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            onTap(index);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Widget _createSettingsItem(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Divider(),
          InkWell(
            child: Container(
              height: 64,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.settings,
                      color: Theme.of(context).disabledColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Text(
                        "Einstellungen",
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, "settings");
            },
          ),
        ],
      ),
    );
  }
}

class DrawerNavigationEntry {
  final Widget icon;
  final String title;

  DrawerNavigationEntry(this.icon, this.title);
}
