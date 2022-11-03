import 'package:dhbwstudentapp/common/data/database_entity.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';

class DateEntryEntity extends DatabaseEntity {
  // TODO: [Leptopoda] make non null
  DateEntry? _dateEntry;

  DateEntryEntity.fromModel(DateEntry dateEntry) : _dateEntry = dateEntry;

  DateEntryEntity.fromMap(Map<String, dynamic> map) {
    fromMap(map);
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    final date = map["date"] as int?;
    DateTime? dateTime;
    if (date != null) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    }

    _dateEntry = DateEntry(
      comment: map["comment"] as String?,
      description: map["description"] as String?,
      year: map["year"] as String?,
      databaseName: map["databaseName"] as String?,
      start: dateTime,
      end: dateTime,
      room: map["room"] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    assert(_dateEntry != null);
    return {
      "date": _dateEntry!.start.millisecondsSinceEpoch,
      "comment": _dateEntry!.comment,
      "description": _dateEntry!.description,
      "year": _dateEntry!.year,
      "databaseName": _dateEntry!.databaseName,
    };
  }

  DateEntry asDateEntry() => _dateEntry!;

  // TODO: [Leptopoda] make getter or even constant.
  static String tableName() => "DateEntries";
}
