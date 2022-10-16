import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/logging/analytics.dart';
import 'package:dhbwstudentapp/common/ui/app_theme.dart';
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
class RootPage extends StatelessWidget {
  final RootViewModel rootViewModel;

  const RootPage({super.key, required this.rootViewModel});

  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider<RootViewModel, String>(
      value: rootViewModel,
      child: PropertyChangeConsumer(
        properties: const ["appTheme", "isOnboarding"],
        builder:
            (BuildContext context, RootViewModel? model, Set? properties) =>
                MaterialApp(
          theme: AppTheme.lightThemeData,
          darkTheme: AppTheme.darkThemeData,
          themeMode: model?.appTheme,
          initialRoute: rootViewModel.isOnboarding ? "onboarding" : "main",
          navigatorKey: NavigatorKey.rootKey,
          navigatorObservers: [rootNavigationObserver],
          localizationsDelegates: const [
            LocalizationDelegate(),
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
    );
  }
}
