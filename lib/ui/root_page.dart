import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/logging/analytics.dart';
import 'package:dhbwstudentapp/common/ui/colors.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/root_view_model.dart';
import 'package:dhbwstudentapp/ui/navigation/navigator_key.dart';
import 'package:dhbwstudentapp/ui/navigation/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

///
/// This is the top level widget of the app. It handles navigation of the
/// root navigator and rebuilds its child widgets on theme changes
///
class RootPage extends StatefulWidget {
  final RootViewModel rootViewModel;

  const RootPage({Key? key, required this.rootViewModel}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider<RootViewModel, String>(
      child: PropertyChangeConsumer(
        properties: const ["appTheme", "isOnboarding"],
        builder:
            (BuildContext context, RootViewModel? model, Set? properties) =>
                MaterialApp(
          theme: ColorPalettes.buildTheme(model!.appTheme),
          initialRoute:
              widget.rootViewModel.isOnboarding ? "onboarding" : "main",
          navigatorKey: NavigatorKey.rootKey,
          navigatorObservers: [rootNavigationObserver],
          localizationsDelegates: [
            const LocalizationDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('de'),
          ],
          onGenerateRoute: generateRoute,
        ),
      ),
      value: widget.rootViewModel,
    );
  }
}
