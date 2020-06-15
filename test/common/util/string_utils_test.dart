import 'package:dhbwstuttgart/common/util/string_utils.dart';
import 'package:test/test.dart';

void main() {
  test('String interpolation', () async {
    var format = "%0 %1!";
    var result = interpolate(format, ["Hello", "world"]);

    expect(result, "Hello world!");
  });
}
