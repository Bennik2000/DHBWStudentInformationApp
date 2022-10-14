import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';
import 'package:flutter/material.dart';

class LoginCredentialsWidget extends StatefulWidget {
  final CredentialsEditingController controller;
  final Function onSubmitted;

  const LoginCredentialsWidget({
    Key? key,
    required this.controller,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  _LoginCredentialsWidgetState createState() => _LoginCredentialsWidgetState();
}

class _LoginCredentialsWidgetState extends State<LoginCredentialsWidget> {
  final _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: widget.controller.username,
          decoration: InputDecoration(
            hintText: L.of(context).loginUsername,
            icon: const Icon(Icons.alternate_email),
          ),
          onSubmitted: (v) {
            FocusScope.of(context).requestFocus(_focus);
          },
          textInputAction: TextInputAction.next,
        ),
        TextField(
          controller: widget.controller.password,
          obscureText: true,
          decoration: InputDecoration(
            hintText: L.of(context).loginPassword,
            icon: const Icon(Icons.lock_outline),
          ),
          focusNode: _focus,
          onSubmitted: (v) {
            widget.onSubmitted();
          },
        ),
      ],
    );
  }
}
