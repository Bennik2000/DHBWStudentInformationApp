import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:dhbwstudentapp/date_management/model/date_search_parameters.dart';
import 'package:dhbwstudentapp/date_management/service/parsing/all_dates_extract.dart';
import 'package:dhbwstudentapp/dualis/service/session.dart';

class DateManagementService {
  const DateManagementService();

  Future<List<DateEntry>> queryAllDates(
    DateSearchParameters parameters,
    CancellationToken? cancellationToken,
  ) async {
    final queryResult = await Session().get(
      _buildRequestUrl(parameters),
      cancellationToken,
    );

    final allDates = const AllDatesExtract().extractAllDates(
      queryResult,
      parameters.databaseName,
    );

    return allDates;
  }

  String _buildRequestUrl(DateSearchParameters parameters) {
    var url = "https://it.dhbw-stuttgart.de/DHermine/?page=texport";

    url += "&sel_typ=pub";
    url += "&sel_jahrgang= ${parameters.year ?? "*"}";
    url += "&sel_bezeichnung=*";
    url += "&selection=${parameters.includePast ? "**" : "*"}";
    url += "&permission=show";
    url += "&sessionid=";
    url += "&user=nobody";
    url += "&DB=${parameters.databaseName}";
    url += "&field=Datum&sort=ASC";

    return url;
  }
}
