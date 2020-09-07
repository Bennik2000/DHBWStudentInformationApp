import 'package:dhbwstudentapp/common/application_constants.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:launch_review/launch_review.dart';
import 'package:flutter/material.dart';

class RateInStore {
  final PreferencesProvider _preferencesProvider;

  RateInStore(this._preferencesProvider);

  Future<void> showRateInStoreDialogIfNeeded(BuildContext context) async {
    final countdown =
        await _preferencesProvider.getRateInStoreLaunchCountdown();

    if (countdown <= 0) {
      if (await _preferencesProvider.getDontShowRateNowDialog()) return;

      await _showRateDialog(context);
    } else {
      await _preferencesProvider.setRateInStoreLaunchCountdown(countdown - 1);
    }
  }

  Future<void> _showRateDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          buttonPadding: const EdgeInsets.all(0),
          actionsPadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          title: Text(L.of(context).rateDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(L.of(context).rateDialogMessage),
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
        FlatButton(
          child: Text(L.of(context).rateDialogDoNotRateButton.toUpperCase()),
          onPressed: () {
            _rateNever();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(L.of(context).rateDialogRateLaterButton.toUpperCase()),
          onPressed: () {
            _rateLater();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(L.of(context).rateDialogRateNowButton.toUpperCase()),
          onPressed: () {
            _rateNow();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<void> _rateLater() async {
    await _preferencesProvider
        .setRateInStoreLaunchCountdown(RateInStoreCountdownNumber);
  }

  Future<void> _rateNow() async {
    LaunchReview.launch();
    await _preferencesProvider.setDontShowRateNowDialog(true);
  }

  Future<void> _rateNever() async {
    await _preferencesProvider.setDontShowRateNowDialog(true);
  }
}
