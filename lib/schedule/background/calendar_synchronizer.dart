import 'package:device_calendar/device_calendar.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/date_management/data/calendar_access.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_provider.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:kiwi/kiwi.dart';

class CalendarSynchronizer {
  final ScheduleProvider scheduleProvider;
  final ScheduleSourceProvider scheduleSourceProvider;
  final PreferencesProvider preferencesProvider;

  CalendarSynchronizer(this.scheduleProvider, this.scheduleSourceProvider,
      this.preferencesProvider);

  void registerSynchronizationCallback() {
    scheduleProvider.addScheduleUpdatedCallback((schedule, start, end) async {
      List<DateEntry> listDateEntries = List<DateEntry>.empty(growable: true);
      schedule.entries.forEach(
        (element) {
          DateEntry date = DateEntry(
              room: element.room,
              comment: element.details,
              databaseName: 'DHBW',
              description: element.title,
              year: element.start.year.toString(),
              start: element.start,
              end: element.end);
          listDateEntries.add(date);
        },
      );
      KiwiContainer().resolve<ListDateEntries30d>().listDateEntries =
          listDateEntries;

      if (await preferencesProvider.isCalendarSyncEnabled()) {
        Calendar? selectedCalendar =
            await preferencesProvider.getSelectedCalendar();
        if (selectedCalendar == null) return;
        CalendarAccess().addOrUpdateDates(listDateEntries, selectedCalendar);
      }
    });
  }

  void scheduleSyncInAFewSeconds() {
    Future.delayed(Duration(seconds: 10), () {
      if (!scheduleSourceProvider.didSetupCorrectly()) return;
      scheduleProvider.getUpdatedSchedule(
        DateTime.now(),
        DateTime.now().add(Duration(days: 30)),
        CancellationToken(),
      );
    });
  }
}

class ListDateEntries30d {
  List<DateEntry> listDateEntries;
  ListDateEntries30d(this.listDateEntries);
}
