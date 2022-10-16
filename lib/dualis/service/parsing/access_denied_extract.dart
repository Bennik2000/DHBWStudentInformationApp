class AccessDeniedExtract {
  const AccessDeniedExtract();

  bool isAccessDeniedPage(String body) {
    return body.contains("Zugang verweigert");
  }
}
