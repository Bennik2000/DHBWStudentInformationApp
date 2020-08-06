import 'package:dhbwstudentapp/common/ui/rate_in_store.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_setup.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:dhbwstudentapp/ui/navigation/navigator_key.dart';
import 'package:dhbwstudentapp/ui/navigation/router.dart';
import 'package:dhbwstudentapp/ui/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kiwi/kiwi.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentEntryIndex = 0;
  bool _rateDialogShown = false;

  NavigationEntry get currentEntry => navigationEntries[_currentEntryIndex];

  @override
  void initState() {
    super.initState();
    ScheduleSourceSetup()
        .setupScheduleSource(); // TODO: Move this somewhere else!
  }

  @override
  Widget build(BuildContext context) {
    _showRateInStoreDialogIfNeeded(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        textTheme: Theme.of(context).textTheme,
        actionsIconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        brightness: Theme.of(context).brightness,
        iconTheme: Theme.of(context).iconTheme,
        title: Text(navigationEntries[_currentEntryIndex].title(context)),
        actions: currentEntry.appBarActions(context),
      ),
      body: Navigator(
        key: NavigatorKey.key,
        onGenerateRoute: generateDrawerRoute,
      ),
      drawer: NavigationDrawer(
        selectedIndex: _currentEntryIndex,
        onTap: _onNavigationTapped,
        entries: _buildDrawerEntries(),
      ),
    );
  }

  List<DrawerNavigationEntry> _buildDrawerEntries() {
    var drawerEntries = <DrawerNavigationEntry>[];

    for (var entry in navigationEntries) {
      drawerEntries.add(DrawerNavigationEntry(
        entry.icon(context),
        entry.title(context),
      ));
    }

    return drawerEntries;
  }

  void _onNavigationTapped(int index) {
    _currentEntryIndex = index;
    NavigatorKey.key.currentState.pushReplacementNamed(currentEntry.route);

    setState(() {});
  }

  void _showRateInStoreDialogIfNeeded(BuildContext context) {
    if (!_rateDialogShown) {
      RateInStore(KiwiContainer().resolve())
          .showRateInStoreDialogIfNeeded(context);

      _rateDialogShown = true;
    }
  }
}
