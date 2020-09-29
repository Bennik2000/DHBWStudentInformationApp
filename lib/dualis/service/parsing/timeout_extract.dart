class TimeoutExtract {
  bool isTimeoutErrorPage(String body) {
    return body.contains("Timeout!") &&
        body.contains("Bitte melden Sie sich erneut");
  }
}
