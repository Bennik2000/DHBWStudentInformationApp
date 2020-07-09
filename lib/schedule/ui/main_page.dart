import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/dualis/ui/exam_results_page/exam_results_page.dart';
import 'package:dhbwstudentapp/dualis/ui/study_overview/study_overview_page.dart';
import 'package:dhbwstudentapp/dualis/ui/viewmodels/study_grades_view_model.dart';
import 'package:dhbwstudentapp/information/ui/usefulinformation/useful_information_page.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_setup.dart';
import 'package:dhbwstudentapp/schedule/ui/dailyschedule/daily_schedule_page.dart';
import 'package:dhbwstudentapp/schedule/ui/dailyschedule/viewmodels/daily_schedule_view_model.dart';
import 'package:dhbwstudentapp/schedule/ui/navigation_drawer.dart';
import 'package:dhbwstudentapp/schedule/ui/settings/settings_page.dart';
import 'package:dhbwstudentapp/schedule/ui/weeklyschedule/viewmodels/weekly_schedule_view_model.dart';
import 'package:dhbwstudentapp/schedule/ui/weeklyschedule/weekly_schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentEntryIndex = 0;

  final List<NavigationEntry> navigationEntries = [
    NavigationEntry.pages(
      <Page>[
        Page(
          widget: WeeklySchedulePage(),
          title: (BuildContext context) => L.of(context).pageWeekOverviewTitle,
          viewModel: WeeklyScheduleViewModel(kiwi.Container().resolve()),
          key: Key("Weekly"),
          icon: Icons.view_week,
        ),
        Page(
          widget: DailySchedulePage(),
          title: (BuildContext context) => L.of(context).pageDayOverviewTitle,
          viewModel: DailyScheduleViewModel(kiwi.Container().resolve()),
          key: Key("Daily"),
          icon: Icons.calendar_view_day,
        ),
      ],
      Icon(Icons.calendar_today),
      (BuildContext context) => L.of(context).screenScheduleTitle,
      null,
    ),
    NavigationEntry.pages(
      <Page>[
        Page(
          widget: StudyOverviewPage(),
          title: (BuildContext context) => L.of(context).pageDualisOverview,
          viewModel: null,
          key: Key("StudyOverview"),
          icon: Icons.dashboard,
        ),
        Page(
          widget: ExamResultsPage(),
          title: (BuildContext context) => L.of(context).pageDualisExams,
          viewModel: null,
          key: Key("Exams"),
          icon: Icons.book,
        ),
      ],
      Icon(Icons.data_usage),
      (BuildContext context) => L.of(context).screenDualisTitle,
      StudyGradesViewModel(),
    ),
    NavigationEntry.body(
      UsefulInformationPage(),
      Icon(Icons.info_outline),
      (BuildContext context) => L.of(context).screenUsefulLinks,
      null,
    ),
  ];

  void onTabTapped(int index) {
    setState(() {
      var entry = navigationEntries[_currentEntryIndex];

      if (entry.hasPages) {
        entry.currentPageIndex = index;
      }
    });
  }

  void onNavigationTapped(int index) {
    setState(() {
      _currentEntryIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    ScheduleSourceSetup().setupScheduleSource();
  }

  @override
  Widget build(BuildContext context) {
    var body;
    var bodyKey;
    BaseViewModel viewModel;
    BaseViewModel baseViewModel;

    var currentEntry = navigationEntries[_currentEntryIndex];

    if (currentEntry.hasPages) {
      body = currentEntry.currentPage.widget;
      bodyKey = currentEntry.currentPage.key;
      viewModel = currentEntry.currentPage.viewModel;
      baseViewModel = currentEntry.viewModel;
    } else {
      body = currentEntry.body;
      bodyKey = currentEntry.key;
      viewModel = currentEntry.viewModel;
    }

    var drawerEntries = <DrawerNavigationEntry>[];

    for (var entry in navigationEntries) {
      drawerEntries
          .add(DrawerNavigationEntry(entry.icon, entry.title(context)));
    }

    var bottomNavigationItems = <BottomNavigationBarItem>[];

    for (Page page in currentEntry.pages ?? []) {
      bottomNavigationItems.add(
        new BottomNavigationBarItem(
          icon: Icon(page.icon),
          title: Text(page.title(context)),
        ),
      );
    }

    if (viewModel != null) {
      body = ChangeNotifierProvider.value(
        key: bodyKey,
        value: viewModel,
        child: body,
      );
    }

    if (baseViewModel != null) {
      body = ChangeNotifierProvider.value(
        key: bodyKey,
        value: baseViewModel,
        child: body,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        textTheme: Theme.of(context).textTheme,
        actionsIconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        brightness: Theme.of(context).brightness,
        iconTheme: Theme.of(context).iconTheme,
        title: Text(navigationEntries[_currentEntryIndex].title(context)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SettingsPage()));
            },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        child: Column(
          key: bodyKey,
          children: <Widget>[
            Expanded(
              child: body,
            ),
          ],
        ),
        duration: Duration(milliseconds: 200),
      ),
      bottomNavigationBar: currentEntry.hasPages
          ? BottomNavigationBar(
              onTap: onTabTapped,
              currentIndex: currentEntry.currentPageIndex,
              items: bottomNavigationItems)
          : null,
      drawer: NavigationDrawer(
        selectedIndex: _currentEntryIndex,
        onTap: onNavigationTapped,
        entries: drawerEntries,
      ),
    );
  }
}

class Page {
  final Widget widget;
  final Color color;
  final String Function(BuildContext context) title;
  final IconData icon;
  final BaseViewModel viewModel;
  final Key key;

  Page({
    this.widget,
    this.color,
    this.title,
    this.viewModel,
    this.key,
    this.icon,
  });
}

class NavigationEntry {
  final Widget icon;
  final String Function(BuildContext context) title;
  final BaseViewModel viewModel;

  List<Page> _pages;
  List<Page> get pages => _pages;

  int currentPageIndex = 0;
  Page get currentPage => pages[currentPageIndex];

  Widget _body;
  Widget get body => _body;

  bool get hasPages => _pages != null && _pages.length > 0;
  Key get key => ValueKey(title);

  NavigationEntry.pages(this._pages, this.icon, this.title, this.viewModel);
  NavigationEntry.body(this._body, this.icon, this.title, this.viewModel);
}
