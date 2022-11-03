class DateSearchParameters {
  bool? includePast;
  bool? includeFuture;
  String? year;
  String? databaseName;

  DateSearchParameters(
    this.includePast,
    this.includeFuture,
    this.year,
    this.databaseName,
  );

  @override
  String toString() {
    return "includePast=$includePast;includeFuture=$includeFuture;year=$year;databaseName=$databaseName";
  }
}
