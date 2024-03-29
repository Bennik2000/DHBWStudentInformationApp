import 'package:device_calendar/device_calendar.dart';
import 'package:dhbwstudentapp/common/logging/crash_reporting.dart';
import 'package:dhbwstudentapp/common/util/date_utils.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart' as tz;



enum CalendarPermission {
  PermissionGranted,
  PermissionDenied,
}

///
/// Provides easy access to basic calendar functions. Allows to query the device
/// calendars and add appointments to it
///
class CalendarAccess {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();


  Future<CalendarPermission> requestCalendarPermission() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();

      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return CalendarPermission.PermissionDenied;
        }
      }

      return CalendarPermission.PermissionGranted;
    } on PlatformException catch (e, trace) {
      reportException(e, trace);
    }

    return CalendarPermission.PermissionDenied;
  }

  Future<List<Calendar>> queryWriteableCalendars() async {
    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    var writeableCalendars = <Calendar>[];
    for (var calendar in calendarsResult?.data ?? <Calendar>[]) {
      if (!calendar.isReadOnly) {
        writeableCalendars.add(calendar);
      }
    }

    return writeableCalendars;
  }

  Future<void> addOrUpdateDates(
    List<DateEntry> dateEntries,
    Calendar calendar,
  ) async {
    if ((dateEntries ?? []).isEmpty) return;

    var existingEvents =
        await _getExistingEventsFromCalendar(dateEntries, calendar);

    for (var entry in dateEntries) {
      await _addOrUpdateEntry(existingEvents, entry, calendar);
    }
  }

  Future _addOrUpdateEntry(
      List<Event> existingEvents, DateEntry entry, Calendar calendar) async {
    // Find the id in the existing events in order that the "update" part of
    // createOrUpdateEvent(...) works
    var id = _getIdOfExistingEvent(existingEvents, entry);

    var isAllDay, start, end;
    if (entry.start.isAtSameMomentAs(entry.end)) {
      isAllDay = isAtMidnight(entry.start);
      start = entry.start;
      end = isAllDay ? start : start.add(const Duration(minutes: 30));
    } else {
      isAllDay = false;
      start = entry.start;
      end = entry.end;
    }


    return await _deviceCalendarPlugin.createOrUpdateEvent(Event(
      calendar.id,
      location: entry.room,
      title: entry.description,
      description: "${entry.comment}",
      eventId: id,
      allDay: isAllDay,
      start: tz.TZDateTime.from(start, tz.getLocation('Europe/Berlin')),
      end: tz.TZDateTime.from(end, tz.getLocation('Europe/Berlin')),
    ));
  }

  String _getIdOfExistingEvent(List<Event> existingEvents, DateEntry entry) {
    var existingEvent = existingEvents
        .where((element) => (element.title == entry.description && element.start.toUtc().isAtSameMomentAs(entry.start.toUtc())))
        .toList();
    String id;

    if (existingEvent.isNotEmpty) {
      id = existingEvent[0].eventId;
    }
    return id;
  }

  Future<List<Event>> _getExistingEventsFromCalendar(
      List<DateEntry> dateEntries, Calendar calendar) async {
    var firstEntry = _findFirstEntry(dateEntries);
    var lastEntry = _findLastEntry(dateEntries);

    var existingEventsResult = await _deviceCalendarPlugin.retrieveEvents(
        calendar.id,
        RetrieveEventsParams(
          startDate: firstEntry.start,
          endDate: lastEntry.end,
        ));

    var existingEvents = <Event>[];

    if (existingEventsResult.isSuccess) {
      existingEvents = existingEventsResult.data.toList();
    }
    return existingEvents;
  }

  DateEntry _findFirstEntry(List<DateEntry> entries) {
    var firstEntry = entries[0];

    for (var entry in entries) {
      if (entry.end.isBefore(firstEntry?.end)) {
        firstEntry = entry;
      }
    }

    return firstEntry;
  }

  DateEntry _findLastEntry(List<DateEntry> entries) {
    var lastEntry = entries[0];

    for (var entry in entries) {
      if (entry.end.isAfter(lastEntry.end)) {
        lastEntry = entry;
      }
    }

    return lastEntry;
  }
}
