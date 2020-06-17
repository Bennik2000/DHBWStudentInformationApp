import 'package:dhbwstuttgart/common/i18n/localizations.dart';
import 'package:dhbwstuttgart/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstuttgart/schedule/business/schedule_source_setup.dart';
import 'package:dhbwstuttgart/schedule/ui/dailyschedule/daily_schedule_page.dart';
import 'package:dhbwstuttgart/schedule/ui/dailyschedule/viewmodels/daily_schedule_view_model.dart';
import 'package:dhbwstuttgart/schedule/ui/navigation_drawer.dart';
import 'package:dhbwstuttgart/schedule/ui/settings/settings_page.dart';
import 'package:dhbwstuttgart/schedule/ui/weeklyschedule/viewmodels/weekly_schedule_view_model.dart';
import 'package:dhbwstuttgart/schedule/ui/weeklyschedule/weekly_schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentPageIndex = 0;

  final List<Page> pages = <Page>[
    Page(
      widget: WeeklySchedulePage(),
      title: (BuildContext context) => L.of(context).pageWeekOverviewTitle,
      viewModel: WeeklyScheduleViewModel(kiwi.Container().resolve()),
      key: Key("Weekly"),
    ),
    Page(
      widget: DailySchedulePage(),
      title: (BuildContext context) => L.of(context).pageDayOverviewTitle,
      viewModel: DailyScheduleViewModel(kiwi.Container().resolve()),
      key: Key("Daily"),
    ),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    ScheduleSourceSetup().setupScheduleSource();
  }

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
        title: Text(pages[_currentPageIndex].title(context)),
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
          key: pages[_currentPageIndex].key,
          children: <Widget>[
            Expanded(
              child: ChangeNotifierProvider.value(
                key: pages[_currentPageIndex].key,
                value: pages[_currentPageIndex].viewModel,
                child: pages[_currentPageIndex].widget,
              ),
            ),
          ],
        ),
        duration: Duration(milliseconds: 200),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentPageIndex,
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
            icon: Icon(Icons.view_week),
            title: Text(L.of(context).pageWeekOverviewTitle),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_day),
            title: Text(L.of(context).pageDayOverviewTitle),
          )
        ],
      ),
      drawer: NavigationDrawer(),
    );
  }
}

class Page {
  final Widget widget;
  final Color color;
  final String Function(BuildContext context) title;
  final BaseViewModel viewModel;
  final Key key;

  Page({this.widget, this.color, this.title, this.viewModel, this.key});
}
