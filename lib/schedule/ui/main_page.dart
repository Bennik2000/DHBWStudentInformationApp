import 'package:dhbwstuttgart/common/data/database_access.dart';
import 'package:dhbwstuttgart/common/ui/base_view_model.dart';
import 'package:dhbwstuttgart/schedule/business/schedule_provider.dart';
import 'package:dhbwstuttgart/schedule/data/schedule_entry_repository.dart';
import 'package:dhbwstuttgart/schedule/service/rapla/rapla_schedule_source.dart';
import 'package:dhbwstuttgart/schedule/ui/dailyschedule/daily_schedule_page.dart';
import 'package:dhbwstuttgart/schedule/ui/dailyschedule/viewmodels/daily_schedule_view_model.dart';
import 'package:dhbwstuttgart/schedule/ui/weeklyschedule/viewmodels/weekly_schedule_view_model.dart';
import 'package:dhbwstuttgart/schedule/ui/weeklyschedule/weekly_schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentPageIndex = 0;

  static final ScheduleProvider scheduleProvider = new ScheduleProvider(
    new RaplaScheduleSource(
        "https://rapla.dhbw-stuttgart.de/rapla?key=txB1FOi5xd1wUJBWuX8lJhGDUgtMSFmnKLgAG_NVMhCn4AzVqTBQM-yMcTKkIDCa"),
    new ScheduleEntryRepository(new DatabaseAccess()),
  );

  final List<Page> pages = <Page>[
    Page(
      widget: WeeklySchedulePage(),
      title: "Wochenübersicht",
      viewModel: WeeklyScheduleViewModel(scheduleProvider),
      key: Key("Weekly"),
    ),
    Page(
      widget: DailySchedulePage(),
      title: "Tagesübersicht",
      viewModel: DailyScheduleViewModel(scheduleProvider),
      key: Key("Daily"),
    ),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pages[_currentPageIndex].title),
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
