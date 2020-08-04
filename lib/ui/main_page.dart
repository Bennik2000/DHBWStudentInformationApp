import 'package:dhbwstudentapp/common/ui/rate_in_store.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/dualis/ui/dualis_navigation_entry.dart';
import 'package:dhbwstudentapp/information/ui/useful_information_navigation_entry.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_setup.dart';
import 'package:dhbwstudentapp/schedule/ui/schedule_navigation_entry.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:dhbwstudentapp/ui/navigation/pageable_navigation_entry.dart';
import 'package:dhbwstudentapp/ui/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<NavigationEntry> navigationEntries = [
    ScheduleNavigationEntry(),
    DualisNavigationEntry(),
    UsefulInformationNavigationEntry(),
  ];

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
      body: _buildBody(),
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
    setState(() {
      _currentEntryIndex = index;
    });
  }

  void _showRateInStoreDialogIfNeeded(BuildContext context) {
    if (!_rateDialogShown) {
      RateInStore(KiwiContainer().resolve())
          .showRateInStoreDialogIfNeeded(context);

      _rateDialogShown = true;
    }
  }

  Widget _buildBody() {
    return AnimatedSwitcher(
      child: Column(
        key: currentEntry.key,
        children: <Widget>[
          Expanded(
            child: _wrapWithChangeNotifier(
              currentEntry.build(context),
              currentEntry.viewModel(),
            ),
          ),
        ],
      ),
      duration: Duration(milliseconds: 200),
    );
  }

  Widget _wrapWithChangeNotifier(
    Widget child,
    BaseViewModel changeNotifier,
  ) {
    if (changeNotifier != null) {
      return ChangeNotifierProvider.value(
        value: changeNotifier,
        child: child,
      );
    }

    return child;
  }
}
