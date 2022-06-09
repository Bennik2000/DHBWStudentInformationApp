class DateEntry {
  final String description;
  final String year;
  final DateTime dateAndTime;
  final String comment;
  final String databaseName;
  DateTime start;
  DateTime end;

  DateEntry({
    this.description,
    this.year,
    this.dateAndTime,
    this.comment,
    this.databaseName,
    this.start,
    this.end
  });
}
