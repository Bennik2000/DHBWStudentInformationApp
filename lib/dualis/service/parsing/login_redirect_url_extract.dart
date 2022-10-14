import 'package:html/parser.dart';

class LoginRedirectUrlExtract {
  String? readRedirectUrl(String? body, String redirectUrl) {
    final document = parse(body);

    final metaTags = document.getElementsByTagName("meta");

    String? redirectContent;

    for (final metaTag in metaTags) {
      if (!metaTag.attributes.containsKey("http-equiv")) continue;

      final httpEquiv = metaTag.attributes["http-equiv"];

      if (httpEquiv != "refresh") continue;
      if (!metaTag.attributes.containsKey("content")) continue;

      redirectContent = metaTag.attributes["content"];
      break;
    }

    return getUrlFromHeader(redirectContent, redirectUrl);
  }

  String? getUrlFromHeader(String? refreshHeader, String endpointUrl) {
    if (refreshHeader == null || !refreshHeader.contains("URL=")) return null;

    final refreshHeaderUrlIndex = refreshHeader.indexOf("URL=") + "URL=".length;
    return endpointUrl + refreshHeader.substring(refreshHeaderUrlIndex);
  }
}
