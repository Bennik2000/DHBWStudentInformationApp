class DateSearchParameters {
  final bool includePast;
  final bool includeFuture;
  final String? year;
  final String? databaseName;

  const DateSearchParameters(
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
