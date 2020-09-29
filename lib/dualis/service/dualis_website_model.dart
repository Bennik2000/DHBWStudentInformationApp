import 'package:dhbwstudentapp/dualis/model/exam.dart';

///
/// Stores all important urls to navigate within dualis. It also handles the
/// access token contained within the urls.
///
class DualisUrls {
  final RegExp _tokenRegex = RegExp("ARGUMENTS=-N([0-9]{15})");

  String courseResultUrl;
  String studentResultsUrl;
  String logoutUrl;
  String mainPageUrl;
  String monthlyScheduleUrl;

  Map<String, String> semesterCourseResultUrls = {};

  String _urlToken;

  ///
  /// After the login sequence call this method with an url which contains the
  /// new access token.
  ///
  void updateAccessToken(String urlWithNewToken) {
    var tokenMatch = _tokenRegex.firstMatch(urlWithNewToken);

    if (tokenMatch == null) return;

    _urlToken = tokenMatch.group(1);
  }

  ///
  /// The dualis urls contain an access token which changes with every new login.
  /// When an api call is made with an old access token it will result in a
  /// permission denied error. So before every api call you have to fill in the
  /// updated api token
  ///
  String fillUrlWithToken(String url) {
    var match = _tokenRegex.firstMatch(url);
    if (match != null) {
      return url.replaceRange(match.start, match.end, "ARGUMENTS=-N$_urlToken");
    }

    return url;
  }
}

class DualisSemester {
  final String semesterName;
  final String semesterCourseResultsUrl;
  final List<DualisModule> modules;

  DualisSemester(
    this.semesterName,
    this.semesterCourseResultsUrl,
    this.modules,
  );
}

class DualisModule {
  final String id;
  final String name;
  final String finalGrade;
  final String credits;
  final String detailsUrl;
  final ExamState state;

  DualisModule(
    this.id,
    this.name,
    this.finalGrade,
    this.credits,
    this.state,
    this.detailsUrl,
  );
}

class DualisExam {
  final String tryNr;
  final String moduleName;
  final String name;
  final String grade;
  final String semester;

  DualisExam(
    this.name,
    this.moduleName,
    this.grade,
    this.tryNr,
    this.semester,
  );
}
