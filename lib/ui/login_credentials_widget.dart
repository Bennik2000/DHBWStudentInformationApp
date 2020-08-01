import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:flutter/material.dart';

class LoginCredentialsWidget extends StatefulWidget {
  final TextEditingController usernameEditingController;
  final TextEditingController passwordEditingController;
  final Function onSubmitted;

  const LoginCredentialsWidget({
    Key key,
    this.usernameEditingController,
    this.passwordEditingController,
    this.onSubmitted,
  }) : super(key: key);

  @override
  _LoginCredentialsWidgetState createState() => _LoginCredentialsWidgetState(
        usernameEditingController,
        passwordEditingController,
        onSubmitted,
      );
}

class _LoginCredentialsWidgetState extends State<LoginCredentialsWidget> {
  final TextEditingController _usernameEditingController;
  final TextEditingController _passwordEditingController;
  final Function _onSubmitted;

  final _focus = FocusNode();

  _LoginCredentialsWidgetState(
    this._usernameEditingController,
    this._passwordEditingController,
    this._onSubmitted,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _usernameEditingController,
          decoration: InputDecoration(
            hintText: L.of(context).loginUsername,
            icon: Icon(Icons.alternate_email),
          ),
          onSubmitted: (v) {
            FocusScope.of(context).requestFocus(_focus);
          },
          textInputAction: TextInputAction.next,
        ),
        TextField(
          controller: _passwordEditingController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: L.of(context).loginPassword,
            icon: Icon(Icons.lock_outline),
          ),
          focusNode: _focus,
          onSubmitted: (v) {
            if (_onSubmitted != null) {
              _onSubmitted();
            }
          },
        ),
      ],
    );
  }
}
