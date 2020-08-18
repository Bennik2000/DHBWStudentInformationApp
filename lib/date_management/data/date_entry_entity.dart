import 'package:dhbwstudentapp/common/data/database_entity.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';

class DateEntryEntity extends DatabaseEntity {
  DateEntry _dateEntry;

  DateEntryEntity.fromModel(DateEntry dateEntry) {
    _dateEntry = dateEntry;
  }

  DateEntryEntity.fromMap(Map<String, dynamic> map) {
    fromMap(map);
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    var date;
    if (map["date"] != null) {
      date = DateTime.fromMillisecondsSinceEpoch(map["date"]);
    }

    _dateEntry = new DateEntry(
      comment: map["comment"],
      dateAndTime: date,
      description: map["description"],
      year: map["year"],
      databaseName: map["databaseName"],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "date": _dateEntry.dateAndTime?.millisecondsSinceEpoch ?? 0,
      "comment": _dateEntry.comment ?? "",
      "description": _dateEntry.description ?? "",
      "year": _dateEntry.year ?? "",
      "databaseName": _dateEntry.databaseName ?? ""
    };
  }

  DateEntry asDateEntry() => _dateEntry;

  static String tableName() => "DateEntries";
}
