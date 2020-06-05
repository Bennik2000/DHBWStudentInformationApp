import 'package:dhbwstuttgart/common/data/preferences/preferences_access.dart';
import 'package:dhbwstuttgart/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstuttgart/common/ui/colors.dart';
import 'package:dhbwstuttgart/common/ui/viewmodels/root_view_model.dart';
import 'package:dhbwstuttgart/schedule/ui/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

void main() async {
  Intl.defaultLocale = "de";
  await initializeDateFormatting();

  WidgetsFlutterBinding.ensureInitialized();

  var rootViewModel = RootViewModel(PreferencesProvider(PreferencesAccess()));
  await rootViewModel.loadFromPreferences();

  runApp(MyApp(
    rootViewModel: rootViewModel,
  ));
}

class MyApp extends StatelessWidget {
  final RootViewModel rootViewModel;

  const MyApp({
    Key key,
    this.rootViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider(
      child: PropertyChangeConsumer(
        properties: [
          "isDarkMode",
        ],
        builder: (BuildContext context, RootViewModel model, Set properties) =>
            MaterialApp(
          theme: ThemeData(
            brightness: model.isDarkMode ? Brightness.dark : Brightness.light,
            accentColor: ColorPalettes.main[500],
            primarySwatch: ColorPalettes.main,
          ),
          home: MainPage(),
        ),
      ),
      value: rootViewModel,
    );
  }
}
