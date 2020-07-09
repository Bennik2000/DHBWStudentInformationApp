import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';
import 'package:kiwi/kiwi.dart';

class ScheduleSourceSetup {
  ScheduleSource _scheduleSource;
  PreferencesProvider _preferencesProvider;

  ScheduleSourceSetup() {
    _scheduleSource = KiwiContainer().resolve();
    _preferencesProvider = KiwiContainer().resolve();
  }

  Future<void> setupScheduleSource() async {
    _scheduleSource.setEndpointUrl(await _preferencesProvider.getRaplaUrl());
  }
}
