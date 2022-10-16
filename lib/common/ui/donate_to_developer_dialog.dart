import 'package:dhbwstudentapp/common/application_constants.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/iap/in_app_purchase_manager.dart';
import 'package:dhbwstudentapp/common/logging/analytics.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

///
/// Show a dialog which informs the user that there is an option to support the
/// developer
///
class DonateToDeveloperDialog {
  final PreferencesProvider _preferencesProvider;
  final int _appLaunchCounter;

  const DonateToDeveloperDialog(
    this._preferencesProvider,
    this._appLaunchCounter,
  );

  Future<void> showIfNeeded(BuildContext context) async {
    if (await _preferencesProvider.getDidShowDonateDialog()) return;

    if (_appLaunchCounter >= DonateLaunchAfter) {
      await _preferencesProvider.setDidShowDonateDialog(true);
      await _showDialog(context);

      await analytics.logEvent(name: "donateDialogShown");
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
          title: Text(L.of(context).donateDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(L.of(context).donateDialogMessage),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
                      child: Icon(
                        Icons.free_breakfast_outlined,
                        size: 60,
                      ),
                    ),
                  ],
                ),
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
      buttonPadding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
      children: <Widget>[
        TextButton(
          child: Text(L.of(context).donateDialogPositiveButton.toUpperCase()),
          onPressed: () {
            Navigator.of(context).pop();
            KiwiContainer().resolve<InAppPurchaseManager>().donate();
          },
        ),
        TextButton(
          child: Text(L.of(context).donateDialogNegativeButton.toUpperCase()),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
