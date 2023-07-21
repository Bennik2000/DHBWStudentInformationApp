import 'package:html/parser.dart';

class LoginRedirectUrlExtract {
  String readRedirectUrl(String body, String redirectUrl) {
    var document = parse(body);

    var links = document.getElementsByTagName("a");
    for (var link in links) {
      if (!link.text.contains("Startseite")) continue;

      if (!link.attributes.containsKey("href")) continue;

      return redirectUrl + link.attributes["href"];
    }

    return null;
  }

  String getUrlFromHeader(String refreshHeader, String endpointUrl) {
    if (refreshHeader == null || !refreshHeader.contains("URL=")) return null;

    var refreshHeaderUrlIndex = refreshHeader.indexOf("URL=") + "URL=".length;
    return endpointUrl + refreshHeader.substring(refreshHeaderUrlIndex);
  }
}
