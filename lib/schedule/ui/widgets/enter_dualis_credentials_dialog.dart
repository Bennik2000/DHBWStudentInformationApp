import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:dhbwstudentapp/ui/login_credentials_widget.dart';
import 'package:flutter/material.dart';

class EnterDualisCredentialsDialog {
  final PreferencesProvider _preferencesProvider;
  final ScheduleSourceProvider _scheduleSourceProvider;

  final _controller = CredentialsEditingController();

  Credentials? _credentials;

  EnterDualisCredentialsDialog(
    this._preferencesProvider,
    this._scheduleSourceProvider,
  );

  Future show(BuildContext context) async {
    _credentials = await _preferencesProvider.loadDualisCredentials();

    await showDialog(
      context: context,
      builder: _buildDialog,
    );
  }

  AlertDialog _buildDialog(BuildContext context) {
    final credentials = _credentials;
    if (credentials != null) {
      _controller.credentials = credentials;
    }

    return AlertDialog(
      title: Text(L.of(context).onboardingDualisPageTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Text(
              L.of(context).onboardingDualisSourceDescription,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          LoginCredentialsWidget(
            controller: _controller,
            onSubmitted: () async {},
          ),
        ],
      ),
      actions: _buildButtons(context),
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    return <Widget>[
      TextButton(
        child: Text(L.of(context).dialogOk.toUpperCase()),
        onPressed: () async {
          // TODO: [Leptopoda] validate credentials like [DualisLoginViewModel]
          await _preferencesProvider.storeDualisCredentials(
            _controller.credentials,
          );
          await _scheduleSourceProvider.setupForDualis();

          Navigator.of(context).pop();
        },
      ),
    ];
  }
}
