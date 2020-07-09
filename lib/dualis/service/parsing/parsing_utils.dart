import 'package:html/dom.dart';

import 'package:universal_html/html.dart' as html;

String trimAndEscapeString(String htmlString) {
  if (htmlString == null) return null;

  var text = html.Element.span()..appendHtml(htmlString);
  return text.innerText.trim();
}

Element getElementByTagName(
  Document document,
  String localName, [
  int index = 0,
]) {
  var list = document.getElementsByTagName(localName);

  if (index >= list.length) throw ElementNotFoundParseException();

  return list[index];
}

Element getElementByClassName(
  Document document,
  String className, [
  int index = 0,
]) {
  var list = document.getElementsByClassName(className);

  if (index >= list.length) throw ElementNotFoundParseException();

  return list[index];
}

class ParseException implements Exception {
  Object innerException;

  ParseException.withInner(this.innerException);
}

class ElementNotFoundParseException implements ParseException {
  @override
  Object innerException;
}
