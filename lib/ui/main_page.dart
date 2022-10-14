import 'package:dhbwstudentapp/common/logging/analytics.dart';
import 'package:dhbwstudentapp/common/ui/app_launch_dialogs.dart';
import 'package:dhbwstudentapp/common/util/platform_util.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:dhbwstudentapp/ui/navigation/navigator_key.dart';
import 'package:dhbwstudentapp/ui/navigation/router.dart';
import 'package:dhbwstudentapp/ui/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';

///
/// This is the main page widget. It defines the structure of the scaffold,
/// navigation drawer and provides a nested navigator for the content.
/// To navigate to a new route inside this widget use the [NavigatorKey.mainKey]
///
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with NavigatorObserver {
  bool _appLaunchDialogsShown = false;

  final ValueNotifier<int> _currentEntryIndex = ValueNotifier<int>(0);

  NavigationEntry get currentEntry =>
      navigationEntries[_currentEntryIndex.value];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _showAppLaunchDialogsIfNeeded(context);

    final navigator = Navigator(
      key: NavigatorKey.mainKey,
      onGenerateRoute: generateDrawerRoute,
      initialRoute: "schedule",
      observers: [this, mainNavigationObserver],
    );

    return ChangeNotifierProvider.value(
      value: _currentEntryIndex,
      child: Consumer<ValueNotifier<int>>(
        builder: (BuildContext context, value, Widget? child) {
          Widget content;

          if (PlatformUtil.isPhone() || PlatformUtil.isPortrait(context)) {
            content = buildPhoneLayout(context, navigator);
          } else {
            content = buildTabletLayout(context, navigator);
          }

          return content;
        },
      ),
    );
  }

  Widget buildPhoneLayout(BuildContext context, Navigator navigator) {
    return WillPopScope(
      onWillPop: () async {
        final canPop = NavigatorKey.mainKey.currentState!.canPop();

        if (!canPop) return true;

        NavigatorKey.mainKey.currentState!.pop();

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actionsIconTheme: Theme.of(context).iconTheme,
          elevation: 0,
          iconTheme: Theme.of(context).iconTheme,
          title: Text(currentEntry.title(context)),
          actions: currentEntry.appBarActions(context),
          toolbarTextStyle: Theme.of(context).textTheme.bodyText2,
          titleTextStyle: Theme.of(context).textTheme.headline6,
        ),
        body: navigator,
        drawer: NavigationDrawer(
          selectedIndex: _currentEntryIndex.value,
          onTap: _onNavigationTapped,
          entries: _buildDrawerEntries(),
        ),
      ),
    );
  }

  Widget buildTabletLayout(BuildContext context, Navigator navigator) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actionsIconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
        title: Text(currentEntry.title(context)),
        actions: currentEntry.appBarActions(context),
        toolbarTextStyle: Theme.of(context).textTheme.bodyText2,
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ),
      body: Row(
        children: [
          SizedBox(
            height: double.infinity,
            width: 250,
            child: NavigationDrawer(
              selectedIndex: _currentEntryIndex.value,
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
            child: navigator,
            flex: 3,
          ),
        ],
      ),
    );
  }

  List<DrawerNavigationEntry> _buildDrawerEntries() {
    final drawerEntries = <DrawerNavigationEntry>[];

    for (final entry in navigationEntries) {
      drawerEntries.add(DrawerNavigationEntry(
        entry.icon,
        entry.title(context),
      ),);
    }

    return drawerEntries;
  }

  void _onNavigationTapped(int index) {
    _currentEntryIndex.value = index;

    NavigatorKey.mainKey.currentState!
        .pushNamedAndRemoveUntil(currentEntry.route, (route) {
      return route.settings.name == navigationEntries[0].route;
    });
  }

  void _showAppLaunchDialogsIfNeeded(BuildContext context) {
    if (!_appLaunchDialogsShown) {
      AppLaunchDialog(KiwiContainer().resolve()).showAppLaunchDialogs(context);

      _appLaunchDialogsShown = true;
    }
  }

  void updateNavigationDrawer(String? routeName) {
    for (int i = 0; i < navigationEntries.length; i++) {
      if (navigationEntries[i].route == routeName) {
        _currentEntryIndex.value = i;
        break;
      }
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    updateNavigationDrawer(previousRoute!.settings.name);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    updateNavigationDrawer(route.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    updateNavigationDrawer(newRoute!.settings.name);
  }
}
