import 'package:universal_html/html.dart' as html;

String trimAndEscapeString(String htmlString) {
  if (htmlString == null) return null;

  var text = html.Element.span()..appendHtml(htmlString);
  return text.innerText.trim();
}
