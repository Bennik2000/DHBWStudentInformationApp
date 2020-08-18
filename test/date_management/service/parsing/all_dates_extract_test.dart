import 'dart:io';

import 'package:dhbwstudentapp/date_management/service/parsing/all_dates_extract.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var allDatesPage = await new File(Directory.current.absolute.path +
          '/test/date_management/service/parsing/html_resources/all_dates.html')
      .readAsString();

  test('AllDatesExtract extract all dates', () async {
    var extract = AllDatesExtract();

    var dateEntries = extract.extractAllDates(allDatesPage);

    expect(3, dateEntries.length);

    expect("Termin 1", dateEntries[0].description);
    expect("2020", dateEntries[0].year);
    expect("bis 22.12.21", dateEntries[0].comment);
    expect(DateTime(2020, 11, 10, 08, 00), dateEntries[0].dateAndTime);

    expect("Abgabe Studienarbeit", dateEntries[1].description);
    expect("2021", dateEntries[1].year);
    expect("Abgabesystem", dateEntries[1].comment);
    expect(DateTime(2021, 03, 04, 24, 00), dateEntries[1].dateAndTime);

    expect("Abgabe Bachelorarbeit", dateEntries[2].description);
    expect("2019", dateEntries[2].year);
    expect("Gebunden", dateEntries[2].comment);
    expect(DateTime(2021, 08, 09, 15, 45), dateEntries[2].dateAndTime);
  });
}
