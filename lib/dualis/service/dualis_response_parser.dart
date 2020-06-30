import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:html/parser.dart';

class DualisResponseParser {
  final String endpointUrl;

  DualisResponseParser(this.endpointUrl);

  String getUrlFromHeader(String refreshHeader) {
    print(refreshHeader);

    var refreshHeaderUrlIndex = refreshHeader.indexOf("URL=") + "URL=".length;

    return endpointUrl + refreshHeader.substring(refreshHeaderUrlIndex);
  }

  String readRedirectUrl(String body) {
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

    return getUrlFromHeader(redirectContent);
  }

  DualisMainPage parseMainPage(String body) {
    var document = parse(body);

    var courseResultsElement = document.getElementsByClassName("link000307");
    var studentResultsElement = document.getElementsByClassName("link000310");

    var courseResultsUrl =
        endpointUrl + courseResultsElement[0].attributes['href'];

    var studentResultsUrl =
        endpointUrl + studentResultsElement[0].attributes['href'];

    return DualisMainPage(
      courseResultsUrl,
      studentResultsUrl,
    );
  }

  List<DualisSemester> extractSemestersFromCourseResults(String body) {
    var page = parse(body);

    var semesterSelector = page.getElementById("semester");

    var onChange = semesterSelector.attributes["onchange"];

    var regExp = RegExp("'([A-z0-9]*)'");

    var matches = regExp.allMatches(onChange).toList();

    if (matches.length != 4) return null;

    var applicationName = matches[0].group(1);
    var programName = matches[1].group(1);
    var sessionNo = matches[2].group(1);
    var menuId = matches[3].group(1);

    var url = endpointUrl + "/scripts/mgrqispi.dll";
    url += "?APPNAME=$applicationName";
    url += "&PRGNAME=$programName";
    url += "&ARGUMENTS=-N$sessionNo,-N$menuId,-N";

    var semesters = <DualisSemester>[];

    for (var option in semesterSelector.getElementsByTagName("option")) {
      var id = option.attributes["value"];
      var name = option.innerHtml;

      semesters.add(DualisSemester(name, url + id, []));
    }

    return semesters;
  }

  List<DualisModule> extractModulesFromCourseResultPage(String body) {
    var document = parse(body);

    var tableBodies = document.getElementsByTagName("tbody");

    var modulesOfSemester = <DualisModule>[];

    var extractUrlRegex = RegExp('dl_popUp\\("(.+?)"');

    for (var row in tableBodies[0].getElementsByTagName("tr")) {
      if (row.children[0].localName != "td") continue;

      var id = row.children[0].innerHtml.trim();
      var name = row.children[1].innerHtml.trim();
      var grade = row.children[2].innerHtml.trim();
      var credits = row.children[3].innerHtml.trim();
      var status = row.children[4].innerHtml.trim();
      var detailsButton = row.children[5];

      var firstMatch = extractUrlRegex.firstMatch(detailsButton.innerHtml);
      var url = firstMatch?.group(1);
      url = url != null ? endpointUrl + url : null;

      modulesOfSemester.add(
        DualisModule(
          id,
          name,
          grade,
          credits,
          status,
          url,
          <DualisExam>[],
        ),
      );
    }

    return modulesOfSemester;
  }

  List<DualisExam> extractExamsFromCoarsesDetails(String body) {
    var exams = <DualisExam>[];

    var document = parse(body);

    var tableExams = document.getElementsByTagName("tbody")[0];

    var tableExamsRows = tableExams.getElementsByTagName("tr");

    String currentTry;
    String currentModule;

    for (var row in tableExamsRows) {
      var level01s = row.getElementsByClassName("level01");
      if (level01s.length > 0) {
        currentTry = level01s[0].innerHtml.trim();
        continue;
      }

      var level02s = row.getElementsByClassName("level02");
      if (level02s.length > 0) {
        currentModule = level02s[0].innerHtml.trim();
        continue;
      }

      var tbdata = row.getElementsByClassName("tbdata");
      if (tbdata.length > 0) {
        var name = tbdata[1].innerHtml.trim();
        var grade = tbdata[3].innerHtml.trim();

        exams.add(DualisExam(
          name,
          currentModule,
          grade,
          currentTry,
        ));

        continue;
      }
    }

    return exams;
  }
}
