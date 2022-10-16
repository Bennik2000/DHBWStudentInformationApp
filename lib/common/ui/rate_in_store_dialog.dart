import 'package:dhbwstudentapp/common/application_constants.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/logging/analytics.dart';
import 'package:dhbwstudentapp/common/util/platform_util.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';

///
/// Dialog which asks the user to rate the app in the store
///
class RateInStoreDialog {
  final PreferencesProvider _preferencesProvider;
  final int _appLaunchCounter;

  const RateInStoreDialog(this._preferencesProvider, this._appLaunchCounter);

  Future<void> showIfNeeded(BuildContext context) async {
    if (!PlatformUtil.isAndroid()) return;
    if (await _preferencesProvider.getDontShowRateNowDialog()) return;

    if (_appLaunchCounter >=
        await _preferencesProvider.getNextRateInStoreLaunchCount()) {
      await _showRateDialog(context);
    }
  }

  Future<void> _showRateDialog(BuildContext context) async {
    await analytics.logEvent(name: "rateRequestShown");

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          buttonPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
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
        TextButton(
          child: Text(L.of(context).rateDialogDoNotRateButton.toUpperCase()),
          onPressed: () {
            _rateNever();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(L.of(context).rateDialogRateLaterButton.toUpperCase()),
          onPressed: () {
            _rateLater();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
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
    await analytics.logEvent(name: "rateLater");

    await _preferencesProvider.setNextRateInStoreLaunchCount(
      RateInStoreLaunchAfter + _appLaunchCounter,
    );
  }

  Future<void> _rateNow() async {
    LaunchReview.launch();
    await analytics.logEvent(name: "rateNow");
    await _preferencesProvider.setDontShowRateNowDialog(true);
  }

  Future<void> _rateNever() async {
    await analytics.logEvent(name: "rateNever");
    await _preferencesProvider.setDontShowRateNowDialog(true);
  }
}
