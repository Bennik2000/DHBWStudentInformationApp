import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class ScheduleSourceSetup {
  ScheduleSource _scheduleSource;
  PreferencesProvider _preferencesProvider;

  ScheduleSourceSetup() {
    _scheduleSource = kiwi.Container().resolve();
    _preferencesProvider = kiwi.Container().resolve();
  }

  Future<void> setupScheduleSource() async {
    _scheduleSource.setEndpointUrl(await _preferencesProvider.getRaplaUrl());
  }
}
