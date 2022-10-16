import 'package:dhbwstudentapp/common/application_constants.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/util/platform_util.dart';
import 'package:flutter/material.dart';

///
/// Dialog which informs the user, that there is a widget for the home screen
///
class WidgetHelpDialog {
  final PreferencesProvider _preferencesProvider;
  final int _appLaunchCounter;

  const WidgetHelpDialog(this._preferencesProvider, this._appLaunchCounter);

  Future<void> showIfNeeded(BuildContext context) async {
    if (!PlatformUtil.isAndroid()) return;
    if (await _preferencesProvider.getDidShowWidgetHelpDialog()) return;

    if (_appLaunchCounter >= WidgetHelpLaunchAfter) {
      await _preferencesProvider.setDidShowWidgetHelpDialog(true);
      await _showDialog(context);
    }
  }

  Future<void> _showDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          buttonPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          title: Text(L.of(context).widgetHelpDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(L.of(context).widgetHelpDialogMessage),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: _buildButtonBar(context),
              )
            ],
          ),
        );
      },
    );
  }

  ButtonBar _buildButtonBar(BuildContext context) {
    return ButtonBar(
      mainAxisSize: MainAxisSize.max,
      buttonPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      children: <Widget>[
        TextButton(
          child: Text(L.of(context).dialogOk.toUpperCase()),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
