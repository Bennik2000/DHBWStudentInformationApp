import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';

typedef OnDidApplyNewUrl = void Function(bool validUrl);

class ScheduleSourceSetup {
  final ScheduleSource _scheduleSource;
  final PreferencesProvider _preferencesProvider;

  OnDidApplyNewUrl _onDidApplyNewUrl;
  set onDidApplyNewUrl(OnDidApplyNewUrl value) => _onDidApplyNewUrl = value;

  ScheduleSourceSetup(this._scheduleSource, this._preferencesProvider);

  Future<bool> setupScheduleSource() async {
    var raplaUrl = await _preferencesProvider.getRaplaUrl();

    try {
      _scheduleSource.validateEndpointUrl(raplaUrl);
      _scheduleSource.setEndpointUrl(raplaUrl);
    } catch (_) {
      return false;
    }

    return true;
  }

  void applyRaplaUrl(String url) {
    try {
      _scheduleSource.validateEndpointUrl(url);
      _scheduleSource.setEndpointUrl(url);

      _onDidApplyNewUrl?.call(true);
    } catch (_) {
      _onDidApplyNewUrl?.call(false);
    }
  }
}
