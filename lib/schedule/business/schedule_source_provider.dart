import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
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

enum _ScheduleSourceType {
  None,
  Rapla,
  Dualis,
}

class ScheduleSourceProvider {
  final bool _appRunningInBackground;
  final PreferencesProvider _preferencesProvider;

  ScheduleSource _currentScheduleSource = InvalidScheduleSource();
  ScheduleSource get currentScheduleSource => _currentScheduleSource;

  OnDidChangeScheduleSource _onDidChangeScheduleSource;
  set onDidChangeScheduleSource(OnDidChangeScheduleSource value) =>
      _onDidChangeScheduleSource = value;

  ScheduleSourceProvider(
      this._preferencesProvider, this._appRunningInBackground);

  Future<bool> setupScheduleSource() async {
    var scheduleSourceType = await _getScheduleSourceType();

    ScheduleSource scheduleSource = InvalidScheduleSource();

    final initializer = {
      _ScheduleSourceType.Dualis: () async => await _dualisScheduleSource(),
      _ScheduleSourceType.Rapla: () async => await _raplaScheduleSource()
    };

    if (initializer.containsKey(scheduleSourceType)) {
      scheduleSource = await initializer[scheduleSourceType]();
    }

    _currentScheduleSource = scheduleSource;

    var success = didSetupCorrectly();

    _onDidChangeScheduleSource?.call(scheduleSource, success);

    return success;
  }

  Future<_ScheduleSourceType> _getScheduleSourceType() async {
    var type = await _preferencesProvider.getScheduleSourceType();

    var scheduleSourceType = type != null
        ? _ScheduleSourceType.values[type]
        : _ScheduleSourceType.None;

    return scheduleSourceType;
  }

  Future<ScheduleSource> _dualisScheduleSource() async {
    var dualis = DualisScheduleSource(KiwiContainer().resolve());

    var credentials = await _preferencesProvider.loadDualisCredentials();

    if (credentials.allFieldsFilled()) {
      await dualis.authenticateIfNeeded(credentials);
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
        .setScheduleSourceType(_ScheduleSourceType.Rapla.index);

    await setupScheduleSource();
  }

  Future<void> setupForDualis() async {
    await _preferencesProvider
        .setScheduleSourceType(_ScheduleSourceType.Dualis.index);

    await setupScheduleSource();
  }

  bool didSetupCorrectly() {
    return _currentScheduleSource != null &&
        !(_currentScheduleSource is InvalidScheduleSource);
  }
}
