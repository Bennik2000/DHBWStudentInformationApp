class Credentials {
  final String password;
  final String username;

  Credentials(this.username, this.password);

  bool allFieldsFilled() {
    return password != null && username != null;
  }
}
