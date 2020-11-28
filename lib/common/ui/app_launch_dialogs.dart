import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/rate_in_store_dialog.dart';
import 'package:dhbwstudentapp/common/ui/widget_help_dialog.dart';
import 'package:flutter/material.dart';

///
/// Helper class which manages the dialogs which are shown when the app is
/// launched
///
class AppLaunchDialog {
  final PreferencesProvider _preferencesProvider;

  AppLaunchDialog(this._preferencesProvider);

  Future<void> showAppLaunchDialogs(BuildContext context) async {
    final appLaunchCounter = await _preferencesProvider.getAppLaunchCounter();

    await _preferencesProvider.setAppLaunchCounter(appLaunchCounter + 1);

    RateInStoreDialog(_preferencesProvider, appLaunchCounter)
        .showIfNeeded(context);

    WidgetHelpDialog(_preferencesProvider, appLaunchCounter)
        .showIfNeeded(context);
  }
}
