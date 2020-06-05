import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:dhbwstuttgart/common/ui/colors.dart';
import 'package:dhbwstuttgart/common/ui/viewmodels/root_view_model.dart';
import 'package:dhbwstuttgart/schedule/ui/main_page.dart';
import 'package:dhbwstuttgart/service_injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

void main() async {
  await setupLocale();

  WidgetsFlutterBinding.ensureInitialized();

  injectServices();

  runApp(
    PropertyChangeProvider(
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
      value: await setupRootViewModel(),
    ),
  );
}

Future<RootViewModel> setupRootViewModel() async {
  var rootViewModel = RootViewModel(
    kiwi.Container().resolve(),
  );

  await rootViewModel.loadFromPreferences();
  return rootViewModel;
}

Future setupLocale() async {
  Intl.defaultLocale = "de";
  await initializeDateFormatting();
}
