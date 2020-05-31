DateTime toStartOfDay(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
}

DateTime tomorrow(DateTime dateTime) {
  return dateTime.add(Duration(days: 1));
}
