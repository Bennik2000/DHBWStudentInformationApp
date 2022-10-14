import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';
import 'package:flutter/material.dart';

typedef OnLogin = Future<bool> Function(Credentials credentials);
typedef OnLoadCredentials = Future<Credentials?> Function();
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
    Key? key,
    required this.onLogin,
    required this.title,
    required this.loginFailedText,
    required this.onLoadCredentials,
    required this.onSaveCredentials,
    required this.onClearCredentials,
    required this.getDoSaveCredentials,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _storeCredentials = false;
  bool _loginFailed = false;
  bool _isLoading = false;

  final CredentialsEditingController _controller =
      CredentialsEditingController();

  @override
  void initState() {
    super.initState();

    widget.getDoSaveCredentials().then((value) {
      setState(() {
        _storeCredentials = value;
      });

      widget.onLoadCredentials().then((credentials) {
        if (credentials != null) {
          _controller.credentials = credentials;
          if (mounted) {
            setState(() {});
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
          child: widget.title,
        ),
        TextField(
          controller: _controller.username,
          decoration: InputDecoration(
            enabled: !_isLoading,
            hintText: L.of(context).loginUsername,
            icon: const Icon(Icons.alternate_email),
          ),
        ),
        TextField(
          controller: _controller.password,
          obscureText: true,
          decoration: InputDecoration(
            enabled: !_isLoading,
            hintText: L.of(context).loginPassword,
            icon: const Icon(Icons.lock_outline),
            errorText: _loginFailed ? widget.loginFailedText : null,
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
            onChanged: (bool? value) {
              if (value == null) return;
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
                      icon: const Icon(Icons.chevron_right),
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

    if (!_storeCredentials) {
      await widget.onClearCredentials();
    }

    final credentials = _controller.credentials;

    final bool loginSuccess = await widget.onLogin(credentials);

    if (loginSuccess && _storeCredentials) {
      await widget.onSaveCredentials(credentials);
    }

    setState(() {
      _isLoading = false;
      _loginFailed = !loginSuccess;
    });
  }
}
