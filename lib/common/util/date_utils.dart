DateTime toStartOfDay(DateTime dateTime) {
  return dateTime == null
      ? null
      : DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
}

DateTime tomorrow(DateTime dateTime) {
  return dateTime == null ? null : dateTime.add(Duration(days: 1));
}

DateTime toMonday(DateTime dateTime) {
  return dateTime == null
      ? null
      : dateTime.subtract(Duration(days: dateTime.weekday - 1));
}

DateTime toPreviousWeek(DateTime dateTime) {
  return dateTime == null
      ? null
      : DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day - 7,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
        );
}

DateTime toNextWeek(DateTime dateTime) {
  return dateTime == null
      ? null
      : DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day + 7,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
        );
}
