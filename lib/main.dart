import 'package:dhbwstuttgart/schedule/ui/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  Intl.defaultLocale = "de";
  await initializeDateFormatting();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: MaterialColor(0xff990411, const <int, Color>{
          050: const Color(0xFFff838e),
          100: const Color(0xFFff6a77),
          200: const Color(0xFFff5160),
          300: const Color(0xFFff3849),
          400: const Color(0xFFff1f33),
          500: const Color(0xffff061c),
          600: const Color(0xFFe60519),
          700: const Color(0xFFcc0516),
          800: const Color(0xFFb30414),
          900: const Color(0xFF990411),
        }),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MainPage();
  }
}
