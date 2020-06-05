DateTime toStartOfDay(DateTime dateTime) {
  return dateTime == null
      ? null
      : DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
}

DateTime tomorrow(DateTime dateTime) {
  return dateTime == null
      ? null
      : DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day + 1,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
        );
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

bool isAtSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}
