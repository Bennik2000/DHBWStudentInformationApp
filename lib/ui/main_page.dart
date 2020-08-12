import 'package:dhbwstudentapp/common/ui/rate_in_store.dart';
import 'package:dhbwstudentapp/common/util/platform_util.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_setup.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:dhbwstudentapp/ui/navigation/navigator_key.dart';
import 'package:dhbwstudentapp/ui/navigation/router.dart';
import 'package:dhbwstudentapp/ui/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    initializePortraitLandscapeMode();
  }

  @override
  Widget build(BuildContext context) {
    _showRateInStoreDialogIfNeeded(context);

    Widget content;

    if (PlatformUtil.isPhone() || PlatformUtil.isPortrait(context)) {
      content = buildPhoneLayout(context);
    } else {
      content = buildTabletLayout(context);
    }

    return content;
  }

  Widget buildPhoneLayout(BuildContext context) {
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
        key: NavigatorKey.mainKey,
        onGenerateRoute: generateDrawerRoute,
        initialRoute: "schedule",
      ),
      drawer: NavigationDrawer(
        selectedIndex: _currentEntryIndex,
        onTap: _onNavigationTapped,
        entries: _buildDrawerEntries(),
      ),
    );
  }

  Widget buildTabletLayout(BuildContext context) {
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
      body: Row(
        children: [
          SizedBox(
            height: double.infinity,
            width: 250,
            child: NavigationDrawer(
              selectedIndex: _currentEntryIndex,
              onTap: _onNavigationTapped,
              entries: _buildDrawerEntries(),
              isInDrawer: false,
            ),
          ),
          Container(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
          Expanded(
            child: Navigator(
              key: NavigatorKey.mainKey,
              onGenerateRoute: generateDrawerRoute,
              initialRoute: "schedule",
            ),
            flex: 3,
          ),
        ],
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
    NavigatorKey.mainKey.currentState.pushReplacementNamed(currentEntry.route);

    setState(() {});
  }

  void _showRateInStoreDialogIfNeeded(BuildContext context) {
    if (!_rateDialogShown) {
      RateInStore(KiwiContainer().resolve())
          .showRateInStoreDialogIfNeeded(context);

      _rateDialogShown = true;
    }
  }

  void initializePortraitLandscapeMode() {
    if (PlatformUtil.isPhone()) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }
}
