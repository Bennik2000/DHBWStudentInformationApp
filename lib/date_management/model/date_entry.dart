class DateEntry {
  final String description;
  final String year;
  final String comment;
  final String databaseName;
  final DateTime start;
  final DateTime end;
  final String? room;

  DateEntry({
    String? description,
    String? year,
    String? comment,
    String? databaseName,
    DateTime? start,
    DateTime? end,
    this.room,
  })  : start = start ?? DateTime.fromMicrosecondsSinceEpoch(0),
        end = end ?? DateTime.fromMicrosecondsSinceEpoch(0),
        comment = comment ?? "",
        description = description ?? "",
        year = year ?? "",
        databaseName = databaseName ?? "";
}
