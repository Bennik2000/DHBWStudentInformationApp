import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnLogin = Future<bool> Function(String username, String password);

class LoginForm extends StatefulWidget {
  final OnLogin onLogin;
  final Widget title;
  final String loginFailedText;

  const LoginForm({
    Key key,
    this.onLogin,
    this.title,
    this.loginFailedText,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState(
        "",
        onLogin,
        title,
        loginFailedText,
      );
}

class _LoginFormState extends State<LoginForm> {
  final OnLogin _onLogin;
  final Widget title;

  final String loginFailedText;

  bool _loginFailed = false;
  bool _isLoading = false;

  String _username;
  String _password;

  TextEditingController _usernameEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();

  _LoginFormState(
    this._username,
    this._onLogin,
    this.title,
    this.loginFailedText,
  );

  @override
  void initState() {
    super.initState();

    _usernameEditingController.text = _username;
    _passwordEditingController.text = _password;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        title != null
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                child: title,
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
            errorText: _loginFailed ? loginFailedText : null,
          ),
        ),
        Container(
          height: 80,
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
              child: _isLoading
                  ? CircularProgressIndicator()
                  : FlatButton.icon(
                      textColor: Theme.of(context).accentColor,
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

    bool loginSuccess = await _onLogin(
      _usernameEditingController.text,
      _passwordEditingController.text,
    );

    setState(() {
      _isLoading = false;
      _loginFailed = !loginSuccess;
    });
  }
}
