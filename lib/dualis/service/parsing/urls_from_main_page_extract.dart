import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/parsing_utils.dart';
import 'package:html/parser.dart';

class UrlsFromMainPageExtract {
  void parseMainPage(
    String body,
    DualisUrls dualsUrls,
    String endpointUrl,
  ) {
    try {
      _parseMainPage(body, dualsUrls, endpointUrl);
    } catch (e, trace) {
      if (e.runtimeType is ParseException) rethrow;
      throw ParseException.withInner(e, trace);
    }
  }

  void _parseMainPage(
    String body,
    DualisUrls dualisUrls,
    String endpointUrl,
  ) {
    var document = parse(body);

    var courseResultsElement = getElementByClassName(document, "link000307");
    var studentResultsElement = getElementByClassName(document, "link000310");
    var monthlyScheduleElement = getElementByClassName(document, "link000031");
    var logoutElement = getElementById(document, "logoutButton");

    dualisUrls.courseResultUrl =
        endpointUrl + courseResultsElement.attributes['href'];

    dualisUrls.studentResultsUrl =
        endpointUrl + studentResultsElement.attributes['href'];

    dualisUrls.monthlyScheduleUrl =
        endpointUrl + monthlyScheduleElement.attributes["href"];

    dualisUrls.logoutUrl = endpointUrl + logoutElement.attributes['href'];
  }
}
