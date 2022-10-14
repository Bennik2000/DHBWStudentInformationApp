import 'package:dhbwstudentapp/common/util/string_utils.dart';
import 'package:test/test.dart';

void main() {
  test('String interpolation', () async {
    const format = "%0 %1!";
    final result = interpolate(format, ["Hello", "world"]);

    expect(result, "Hello world!");
  });
}
