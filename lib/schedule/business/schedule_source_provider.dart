import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_source_type.dart';
import 'package:dhbwstudentapp/schedule/service/dualis/dualis_schedule_source.dart';
import 'package:dhbwstudentapp/schedule/service/error_report_schedule_source_decorator.dart';
import 'package:dhbwstudentapp/schedule/service/ical/ical_schedule_source.dart';
import 'package:dhbwstudentapp/schedule/service/invalid_schedule_source.dart';
import 'package:dhbwstudentapp/schedule/service/isolate_schedule_source_decorator.dart';
import 'package:dhbwstudentapp/schedule/service/mannheim/mannheim_course_scraper.dart';
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

  List<OnDidChangeScheduleSource> _onDidChangeScheduleSourceCallbacks = [];

  ScheduleSourceProvider(
    this._preferencesProvider,
    this._appRunningInBackground,
  );

  Future<bool> setupScheduleSource() async {
    var scheduleSourceType = await _getScheduleSourceType();

    ScheduleSource scheduleSource = InvalidScheduleSource();

    final initializer = {
      ScheduleSourceType.Dualis: () async => await _dualisScheduleSource(),
      ScheduleSourceType.Rapla: () async => await _raplaScheduleSource(),
      ScheduleSourceType.Ical: () async => await _icalScheduleSource(),
      ScheduleSourceType.Mannheim: () async => await _icalScheduleSource(),
    };

    if (initializer.containsKey(scheduleSourceType)) {
      scheduleSource = await initializer[scheduleSourceType]();
    }

    _currentScheduleSource = scheduleSource;

    var success = didSetupCorrectly();

    _onDidChangeScheduleSourceCallbacks.forEach((element) {
      element(scheduleSource, success);
    });

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

    var credentials = await _preferencesProvider.loadDualisCredentials();

    if (credentials.allFieldsFilled()) {
      dualis.setLoginCredentials(credentials);
      return ErrorReportScheduleSourceDecorator(dualis);
    } else {
      return InvalidScheduleSource();
    }
  }

  Future<ScheduleSource> _raplaScheduleSource() async {
    var raplaUrl = await _preferencesProvider.getRaplaUrl();

    var rapla = RaplaScheduleSource();
    var urlValid = RaplaScheduleSource.isValidUrl(raplaUrl);

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

  Future<ScheduleSource> _icalScheduleSource() async {
    var url = await _preferencesProvider.getIcalUrl();

    var ical = IcalScheduleSource();
    ical.setIcalUrl(url);

    if (ical.canQuery()) {
      ScheduleSource source = ErrorReportScheduleSourceDecorator(ical);

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

  Future<void> setupForIcal(String url) async {
    await _preferencesProvider.setIcalUrl(url);
    await _preferencesProvider
        .setScheduleSourceType(ScheduleSourceType.Ical.index);

    await setupScheduleSource();
  }

  Future<void> setupForMannheim(Course selectedCourse) async {
    await _preferencesProvider.setMannheimScheduleId(selectedCourse.scheduleId);
    await _preferencesProvider.setIcalUrl(selectedCourse.icalUrl);
    await _preferencesProvider
        .setScheduleSourceType(ScheduleSourceType.Mannheim.index);

    await setupScheduleSource();
  }

  bool didSetupCorrectly() {
    return _currentScheduleSource != null &&
        !(_currentScheduleSource is InvalidScheduleSource);
  }

  void addDidChangeScheduleSourceCallback(OnDidChangeScheduleSource callback) {
    _onDidChangeScheduleSourceCallbacks.add(callback);
  }
}
