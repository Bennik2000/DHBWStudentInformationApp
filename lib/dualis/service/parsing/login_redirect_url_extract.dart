import 'package:html/parser.dart';

class LoginRedirectUrlExtract {
  String readRedirectUrl(String body, String redirectUrl) {
    var document = parse(body);

    var metaTags = document.getElementsByTagName("meta");

    var redirectContent;

    for (var metaTag in metaTags) {
      if (!metaTag.attributes.containsKey("http-equiv")) continue;

      var httpEquiv = metaTag.attributes["http-equiv"];

      if (httpEquiv != "refresh") continue;
      if (!metaTag.attributes.containsKey("content")) continue;

      redirectContent = metaTag.attributes["content"];
      break;
    }

    return getUrlFromHeader(redirectContent, redirectUrl);
  }

  String getUrlFromHeader(String refreshHeader, String endpointUrl) {
    if (!refreshHeader.contains("URL=")) return null;

    var refreshHeaderUrlIndex = refreshHeader.indexOf("URL=") + "URL=".length;
    return endpointUrl + refreshHeader.substring(refreshHeaderUrlIndex);
  }
}
