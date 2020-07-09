import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:html/parser.dart';

class UrlsFromMainPageExtract {
  DualisUrls parseMainPage(String body, String endpointUrl) {
    try {
      return _parseMainPage(body, endpointUrl);
    } catch (e) {
      if (e.runtimeType is ParseException) rethrow;
      throw ParseException.withInner(e);
    }
  }

  DualisUrls _parseMainPage(String body, String endpointUrl) {
    var document = parse(body);

    var courseResultsElement = getElementByClassName(document, "link000307");
    var studentResultsElement = getElementByClassName(document, "link000310");

    var courseResultsUrl =
        endpointUrl + courseResultsElement.attributes['href'];

    var studentResultsUrl =
        endpointUrl + studentResultsElement.attributes['href'];

    return DualisUrls(
      courseResultsUrl,
      studentResultsUrl,
    );
  }
}