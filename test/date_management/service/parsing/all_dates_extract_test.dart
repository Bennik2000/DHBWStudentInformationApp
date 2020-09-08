import 'dart:io';

import 'package:dhbwstudentapp/date_management/service/parsing/all_dates_extract.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var allDatesPage = await File(Directory.current.absolute.path +
          '/test/date_management/service/parsing/html_resources/all_dates.html')
      .readAsString();

  test('AllDatesExtract extract all dates', () async {
    var extract = AllDatesExtract();

    var dateEntries = extract.extractAllDates(allDatesPage, "");

    expect(dateEntries.length, 4);

    expect(dateEntries[0].description, "Termin 1");
    expect(dateEntries[0].year, "2020");
    expect(dateEntries[0].comment, "bis 22.12.21");
    expect(dateEntries[0].dateAndTime, DateTime(2020, 11, 10, 08, 00));

    expect(dateEntries[1].description, "Abgabe Studienarbeit");
    expect(dateEntries[1].year, "2021");
    expect(dateEntries[1].comment, "Abgabesystem");
    expect(dateEntries[1].dateAndTime, DateTime(2021, 03, 04, 00, 00));

    expect(dateEntries[2].description, "Abgabe Bachelorarbeit");
    expect(dateEntries[2].year, "2019");
    expect(dateEntries[2].comment, "Gebunden");
    expect(dateEntries[2].dateAndTime, DateTime(2021, 08, 09, 15, 45));

    expect(dateEntries[3].description, "Abgabe Bericht Praxis 1");
    expect(dateEntries[3].year, "2021");
    expect(dateEntries[3].comment, "Elektronisches Abgabesystem");
    expect(dateEntries[3].dateAndTime, DateTime(2022, 09, 05, 00, 00));
  });
}
