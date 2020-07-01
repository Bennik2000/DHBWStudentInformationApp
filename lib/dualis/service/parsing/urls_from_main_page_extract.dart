import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:html/parser.dart';

class UrlsFromMainPageExtract {
  DualisUrls parseMainPage(String body, String endpointUrl) {
    var document = parse(body);

    var courseResultsElement = document.getElementsByClassName("link000307");
    var studentResultsElement = document.getElementsByClassName("link000310");

    var courseResultsUrl =
        endpointUrl + courseResultsElement[0].attributes['href'];

    var studentResultsUrl =
        endpointUrl + studentResultsElement[0].attributes['href'];

    return DualisUrls(
      courseResultsUrl,
      studentResultsUrl,
    );
  }
}
