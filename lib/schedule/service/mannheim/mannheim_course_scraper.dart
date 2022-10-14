import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/schedule/service/mannheim/mannheim_course_response_parser.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart' as http;

class Course {
  final String name;
  final String title;
  final String icalUrl;
  final String scheduleId;

  Course(this.name, this.icalUrl, this.title, this.scheduleId);
}

class MannheimCourseScraper {
  Future<List<Course>> loadCourses([
    CancellationToken? cancellationToken,
  ]) async {
    cancellationToken ??= CancellationToken();

    final coursesPage = await _makeRequest(
      Uri.parse("https://vorlesungsplan.dhbw-mannheim.de/ical.php"),
      cancellationToken,
    );

    return MannheimCourseResponseParser().parseCoursePage(coursesPage.body);
  }

  Future<Response> _makeRequest(
    Uri uri,
    CancellationToken cancellationToken,
  ) async {
    final requestCancellationToken = http.CancellationToken();

    try {
      cancellationToken.cancellationCallback = requestCancellationToken.cancel;

      final response = await http.HttpClientHelper.get(
        uri,
        cancelToken: requestCancellationToken,
      );

      if (response == null && !requestCancellationToken.isCanceled) {
        throw ServiceRequestFailed("Http request failed!");
      }

      return response!;
    // ignore: avoid_catching_errors
    } on http.OperationCanceledError catch (_) {
      throw OperationCancelledException();
    } catch (ex) {
      if (!requestCancellationToken.isCanceled) rethrow;
      throw ServiceRequestFailed("Http request failed!");
    } finally {
      cancellationToken.cancellationCallback = null;
    }
  }
}
