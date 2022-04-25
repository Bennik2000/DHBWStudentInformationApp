import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:dhbwstudentapp/ui/login_credentials_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnterDualisCredentialsDialog {
  final PreferencesProvider _preferencesProvider;
  final ScheduleSourceProvider _scheduleSourceProvider;

  final TextEditingController _usernameEditingController =
      TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  String username;
  String password;

  EnterDualisCredentialsDialog(
    this._preferencesProvider,
    this._scheduleSourceProvider,
  );

  Future show(BuildContext context) async {
    var credentials = await _preferencesProvider.loadDualisCredentials();
    username = credentials.username;
    password = credentials.password;

    await showDialog(
      context: context,
      builder: (context) => _buildDialog(context),
    );
  }

  AlertDialog _buildDialog(BuildContext context) {
    if (_usernameEditingController.text != username) {
      _usernameEditingController.text = username;
    }
    if (_passwordEditingController.text != password) {
      _passwordEditingController.text = password;
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
            usernameEditingController: _usernameEditingController,
            passwordEditingController: _passwordEditingController,
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
          await _preferencesProvider.storeDualisCredentials(
            Credentials(
              _usernameEditingController.text,
              _passwordEditingController.text,
            ),
          );
          await _scheduleSourceProvider.setupForDualis();

          Navigator.of(context).pop();
        },
      ),
    ];
  }
}
