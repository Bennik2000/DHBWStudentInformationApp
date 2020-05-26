import 'package:dhbwstuttgart/schedule/model/schedule.dart';
import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
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
        schedule: Schedule(<ScheduleEntry>[
          ScheduleEntry(
            DateTime(2020, 05, 26, 10, 00),
            DateTime(2020, 05, 26, 11, 20),
            "Informatik",
            "-",
          ),
          ScheduleEntry(
            DateTime(2020, 05, 26, 11, 20),
            DateTime(2020, 05, 26, 13, 00),
            "Mathe",
            "-",
          ),
          ScheduleEntry(
            DateTime(2020, 05, 26, 13, 15),
            DateTime(2020, 05, 26, 15, 45),
            "Physik",
            "-",
          ),
        ]),
      ),
    );
  }
}
