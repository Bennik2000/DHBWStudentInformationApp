import 'package:dhbwstuttgart/common/util/string_utils.dart';
import 'package:dhbwstuttgart/schedule/business/schedule_diff_calculator.dart';
import 'package:dhbwstuttgart/schedule/model/schedule.dart';
import 'package:dhbwstuttgart/schedule/model/schedule_entry.dart';
import 'package:test/test.dart';

void main() {
  test('String interpolation', () async {
    var format = "%0 %1!";
    var result = interpolate(format, ["Hello", "world"]);

    expect(result, "Hello world!");
  });
}
