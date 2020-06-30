import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';
import 'package:test/test.dart';

void main() {
  test('Dualis service debugging', () async {
    var service = DualisServiceImpl();

    var success = await service.login("", "");

    var grade = await service.queryStudyGrades();
  });
}
