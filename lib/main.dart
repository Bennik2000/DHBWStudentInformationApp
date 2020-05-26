import 'package:dhbwstuttgart/schedule/model/schedule.dart';
import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';
import 'package:dhbwstuttgart/schedule/service/rapla/rapla_schedule_source.dart';
import 'package:dhbwstuttgart/schedule/ui/widgets/schedule_entry_widget.dart';
import 'package:dhbwstuttgart/schedule/ui/widgets/schedule_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'DHBW Stuttgart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Schedule schedule;
  int days = 0;

  Future<void> _fetchNextDay() async {
    var s = await RaplaScheduleSource(
            "https://rapla.dhbw-stuttgart.de/rapla?key=txB1FOi5xd1wUJBWuX8lJhGDUgtMSFmnKLgAG_NVMhCn4AzVqTBQM-yMcTKkIDCa")
        .querySchedule(DateTime(2020, 05, 26).add(Duration(days: days)),
            DateTime(2020, 05, 27).add(Duration(days: days)));
    days++;
    setState(() {
      schedule = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ScheduleWidget(
        schedule: schedule,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchNextDay,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
