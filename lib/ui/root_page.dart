import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/colors.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/root_view_model.dart';
import 'package:dhbwstudentapp/ui/navigation/navigator_key.dart';
import 'package:dhbwstudentapp/ui/navigation/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

///
/// This is the top level widget of the app. It handles navigation of the
/// root navigator and rebuilds its child widgets on theme changes
///
class RootPage extends StatefulWidget {
  final RootViewModel rootViewModel;

  const RootPage({Key key, this.rootViewModel}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState(rootViewModel);
}

class _RootPageState extends State<RootPage> {
  final RootViewModel rootViewModel;

  _RootPageState(this.rootViewModel);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider(
      child: PropertyChangeConsumer(
        properties: const ["isDarkMode", "isOnboarding"],
        builder: (BuildContext context, RootViewModel model, Set properties) =>
            PlatformApp(
          material: (_, __) => MaterialAppData(
            theme: ColorPalettes.buildTheme(model.isDarkMode),
          ),
          initialRoute: rootViewModel.isOnboarding ? "onboarding" : "main",
          navigatorKey: NavigatorKey.rootKey,
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
      value: rootViewModel,
    );
  }
}
