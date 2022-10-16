import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Credentials extends Equatable {
  final String username;
  final String password;

  const Credentials(this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}

class CredentialsEditingController {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  CredentialsEditingController([Credentials? credentials]) {
    if (credentials != null) {
      _usernameController.text = credentials.username;
      _passwordController.text = credentials.password;
    }
  }

  set credentials(Credentials credentials) {
    _usernameController.text = credentials.username;
    _passwordController.text = credentials.password;
  }

  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
  }

  TextEditingController get username => _usernameController;
  TextEditingController get password => _passwordController;

  Credentials get credentials => Credentials(
        _usernameController.text,
        _passwordController.text,
      );
}
