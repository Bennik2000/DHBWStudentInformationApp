import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:dhbwstudentapp/date_management/service/parsing/all_dates_extract.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_session.dart';

class DateManagementService {
  Future<List<DateEntry>> queryAllDates(String databaseName) async {
    Session session = Session();

    databaseName = "Termine_Informatik";

    var url =
        "https://it.dhbw-stuttgart.de/DHermine/?page=texport&sel_typ=pub&sel_jahrgang=*&sel_bezeichnung=*&selection=*&permission=show&sessionid=&user=nobody&DB=$databaseName&field=Datum&sort=ASC";

    var queryResult = await session.get(url);

    var allDates = AllDatesExtract().extractAllDates(queryResult);

    return allDates;
  }
}
