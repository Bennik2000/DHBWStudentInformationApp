import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';
import 'package:flutter/material.dart';

typedef OnLogin = Future<bool> Function(Credentials credentials);
typedef OnLoadCredentials = Future<Credentials> Function();
typedef OnSaveCredentials = Future<void> Function(Credentials credentials);
typedef OnClearCredentials = Future<void> Function();
typedef GetDoSaveCredentials = Future<bool> Function();

class LoginForm extends StatefulWidget {
  final OnLogin onLogin;
  final OnLoadCredentials onLoadCredentials;
  final OnSaveCredentials onSaveCredentials;
  final OnClearCredentials onClearCredentials;
  final GetDoSaveCredentials getDoSaveCredentials;

  final Widget title;
  final String loginFailedText;

  const LoginForm({
    Key key,
    this.onLogin,
    this.title,
    this.loginFailedText,
    this.onLoadCredentials,
    this.onSaveCredentials,
    this.onClearCredentials,
    this.getDoSaveCredentials,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState(
        onLogin,
        title,
        loginFailedText,
        onLoadCredentials,
        onSaveCredentials,
        onClearCredentials,
        getDoSaveCredentials,
      );
}

class _LoginFormState extends State<LoginForm> {
  final OnLogin _onLogin;
  final OnLoadCredentials _onLoadCredentials;
  final OnSaveCredentials _onSaveCredentials;
  final OnClearCredentials _onClearCredentials;
  final GetDoSaveCredentials _getDoSaveCredentials;
  final Widget _title;

  final String _loginFailedText;

  bool _storeCredentials = false;
  bool _loginFailed = false;
  bool _isLoading = false;

  final TextEditingController _usernameEditingController =
      TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  _LoginFormState(
    this._onLogin,
    this._title,
    this._loginFailedText,
    this._onLoadCredentials,
    this._onSaveCredentials,
    this._onClearCredentials,
    this._getDoSaveCredentials,
  );

  @override
  void initState() {
    super.initState();

    if (_onLoadCredentials != null && _getDoSaveCredentials != null) {
      _getDoSaveCredentials().then((value) {
        setState(() {
          _storeCredentials = value;
        });

        _onLoadCredentials().then((value) {
          _usernameEditingController.text = value.username;
          _passwordEditingController.text = value.password;

          if (mounted) {
            setState(() {});
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _title != null
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                child: _title,
              )
            : Container(),
        TextField(
          controller: _usernameEditingController,
          decoration: InputDecoration(
            enabled: !_isLoading,
            hintText: L.of(context).loginUsername,
            icon: Icon(Icons.alternate_email),
          ),
        ),
        TextField(
          controller: _passwordEditingController,
          obscureText: true,
          decoration: InputDecoration(
            enabled: !_isLoading,
            hintText: L.of(context).loginPassword,
            icon: Icon(Icons.lock_outline),
            errorText: _loginFailed ? _loginFailedText : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            dense: true,
            title: Text(
              L.of(context).dualisStoreCredentials,
            ),
            onChanged: (bool value) {
              setState(() {
                _storeCredentials = value;
              });
            },
            value: _storeCredentials,
          ),
        ),
        Container(
          height: 80,
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : TextButton.icon(
                      onPressed: () async {
                        await loginButtonPressed();
                      },
                      icon: Icon(Icons.chevron_right),
                      label: Text(L.of(context).loginButton.toUpperCase()),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Future loginButtonPressed() async {
    setState(() {
      _isLoading = true;
    });

    if (!_storeCredentials && _onClearCredentials != null) {
      await _onClearCredentials();
    }

    var credentials = Credentials(
      _usernameEditingController.text,
      _passwordEditingController.text,
    );

    bool loginSuccess = await _onLogin(credentials);

    if (loginSuccess && _storeCredentials && _onSaveCredentials != null) {
      await _onSaveCredentials(credentials);
    }

    setState(() {
      _isLoading = false;
      _loginFailed = !loginSuccess;
    });
  }
}
