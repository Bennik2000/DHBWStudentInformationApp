import 'package:dhbwstuttgart/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstuttgart/schedule/business/schedule_source_setup.dart';
import 'package:dhbwstuttgart/schedule/service/schedule_source.dart';
import 'package:dhbwstuttgart/schedule/ui/dailyschedule/daily_schedule_page.dart';
import 'package:dhbwstuttgart/schedule/ui/dailyschedule/viewmodels/daily_schedule_view_model.dart';
import 'package:dhbwstuttgart/schedule/ui/onboarding/onboarding_page.dart';
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
      title: "Wochenübersicht",
      viewModel: WeeklyScheduleViewModel(kiwi.Container().resolve()),
      key: Key("Weekly"),
    ),
    Page(
      widget: DailySchedulePage(),
      title: "Tagesübersicht",
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
        title: Text(pages[_currentPageIndex].title),
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
            title: Text('Wochenübersicht'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_day),
            title: Text('Tagesübersicht'),
          )
        ],
      ),
    );
  }
}

class Page {
  final Widget widget;
  final Color color;
  final String title;
  final BaseViewModel viewModel;
  final Key key;

  Page({this.widget, this.color, this.title, this.viewModel, this.key});
}
