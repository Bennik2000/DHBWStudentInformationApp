import 'package:dhbwstudentapp/common/application_constants.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/iap/in_app_purchase_helper.dart';
import 'package:dhbwstudentapp/common/iap/in_app_purchase_manager.dart';
import 'package:dhbwstudentapp/common/logging/analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

///
/// Show a dialog which informs the user that there is an option to support the
/// developer
///
class DonateToDeveloperDialog {
  PreferencesProvider _preferencesProvider;
  int _appLaunchCounter;

  DonateToDeveloperDialog(this._preferencesProvider, this._appLaunchCounter);

  void showIfNeeded(BuildContext context) async {
    if (await _preferencesProvider.getDidShowDonateDialog()) return;

    if (_appLaunchCounter >= DonateLaunchAfter) {
      await _preferencesProvider.setDidShowDonateDialog(true);
      await _showDialog(context);

      await analytics.logEvent(name: "donateDialogShown");
    }
  }

  Future<void> _showDialog(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          buttonPadding: const EdgeInsets.all(0),
          actionsPadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          title: Text(L.of(context).donateDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(L.of(context).donateDialogMessage),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                        child: Icon(
                          Icons.free_breakfast_outlined,
                          size: 60,
                        ),
                      ),
                    ],
                  )),
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
        FlatButton(
          child: Text(L.of(context).donateDialogPositiveButton.toUpperCase()),
          onPressed: () {
            Navigator.of(context).pop();
            KiwiContainer().resolve<InAppPurchaseManager>().donate();
          },
        ),
        FlatButton(
          child: Text(L.of(context).donateDialogNegativeButton.toUpperCase()),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
