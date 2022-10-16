import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';
import 'package:flutter/material.dart';

class LoginCredentialsWidget extends StatelessWidget {
  final CredentialsEditingController controller;
  final VoidCallback onSubmitted;

  const LoginCredentialsWidget({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final focus = FocusNode();

    return Column(
      children: <Widget>[
        TextField(
          controller: controller.username,
          decoration: InputDecoration(
            hintText: L.of(context).loginUsername,
            icon: const Icon(Icons.alternate_email),
          ),
          onSubmitted: (v) {
            FocusScope.of(context).requestFocus(focus);
          },
          textInputAction: TextInputAction.next,
        ),
        TextField(
          controller: controller.password,
          obscureText: true,
          decoration: InputDecoration(
            hintText: L.of(context).loginPassword,
            icon: const Icon(Icons.lock_outline),
          ),
          focusNode: focus,
          onSubmitted: (_) => onSubmitted(),
        ),
      ],
    );
  }
}
