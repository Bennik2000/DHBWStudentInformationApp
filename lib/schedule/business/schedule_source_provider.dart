import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_source_type.dart';
import 'package:dhbwstudentapp/schedule/service/dualis/dualis_schedule_source.dart';
import 'package:dhbwstudentapp/schedule/service/error_report_schedule_source_decorator.dart';
import 'package:dhbwstudentapp/schedule/service/invalid_schedule_source.dart';
import 'package:dhbwstudentapp/schedule/service/isolate_schedule_source_decorator.dart';
import 'package:dhbwstudentapp/schedule/service/rapla/rapla_schedule_source.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';
import 'package:kiwi/kiwi.dart';

typedef OnDidChangeScheduleSource = void Function(
  ScheduleSource newSource,
  bool setupSuccess,
);

class ScheduleSourceProvider {
  final bool _appRunningInBackground;
  final PreferencesProvider _preferencesProvider;

  ScheduleSource _currentScheduleSource = InvalidScheduleSource();
  ScheduleSource get currentScheduleSource => _currentScheduleSource;

  OnDidChangeScheduleSource _onDidChangeScheduleSource;
  set onDidChangeScheduleSource(OnDidChangeScheduleSource value) {
    print("Did set _onDidChangeScheduleSource");
    _onDidChangeScheduleSource = value;
  }

  ScheduleSourceProvider(
      this._preferencesProvider, this._appRunningInBackground);

  Future<bool> setupScheduleSource() async {
    print("setupScheduleSource called");
    var scheduleSourceType = await _getScheduleSourceType();
    print("1");

    ScheduleSource scheduleSource = InvalidScheduleSource();

    final initializer = {
      ScheduleSourceType.Dualis: () async => await _dualisScheduleSource(),
      ScheduleSourceType.Rapla: () async => await _raplaScheduleSource(),
    };

    print("2");
    if (initializer.containsKey(scheduleSourceType)) {
      scheduleSource = await initializer[scheduleSourceType]();
    }
    print("3");

    _currentScheduleSource = scheduleSource;

    var success = didSetupCorrectly();
    print("4");

    print("calling onDidChangeScheduleSource...");
    _onDidChangeScheduleSource?.call(scheduleSource, success);
    print("5");

    return success;
  }

  Future<ScheduleSourceType> _getScheduleSourceType() async {
    var type = await _preferencesProvider.getScheduleSourceType();

    var scheduleSourceType = type != null
        ? ScheduleSourceType.values[type]
        : ScheduleSourceType.None;

    return scheduleSourceType;
  }

  Future<ScheduleSource> _dualisScheduleSource() async {
    var dualis = DualisScheduleSource(KiwiContainer().resolve());

    print("_dualisScheduleSource 1");
    var credentials = await _preferencesProvider.loadDualisCredentials();
    print("_dualisScheduleSource 2");

    if (credentials.allFieldsFilled()) {
      dualis.authenticateIfNeeded(credentials);
      return ErrorReportScheduleSourceDecorator(dualis);
    } else {
      return InvalidScheduleSource();
    }
  }

  Future<ScheduleSource> _raplaScheduleSource() async {
    var raplaUrl = await _preferencesProvider.getRaplaUrl();

    var rapla = RaplaScheduleSource();
    var urlValid = rapla.validateEndpointUrl(raplaUrl);

    if (urlValid) {
      rapla.setEndpointUrl(raplaUrl);

      ScheduleSource source = ErrorReportScheduleSourceDecorator(rapla);

      if (!_appRunningInBackground) {
        source = IsolateScheduleSourceDecorator(source);
      }
      return source;
    }

    return InvalidScheduleSource();
  }

  Future<void> setupForRapla(String url) async {
    await _preferencesProvider.setRaplaUrl(url);
    await _preferencesProvider
        .setScheduleSourceType(ScheduleSourceType.Rapla.index);

    await setupScheduleSource();
  }

  Future<void> setupForDualis() async {
    await _preferencesProvider
        .setScheduleSourceType(ScheduleSourceType.Dualis.index);

    await setupScheduleSource();
  }

  bool didSetupCorrectly() {
    print("_currentScheduleSource is $_currentScheduleSource");
    return _currentScheduleSource != null &&
        !(_currentScheduleSource is InvalidScheduleSource);
  }
}
