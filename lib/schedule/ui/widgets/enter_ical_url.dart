import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:dhbwstudentapp/schedule/service/ical/ical_schedule_source.dart';
import 'package:dhbwstudentapp/schedule/ui/widgets/enter_url_dialog.dart';
import 'package:flutter/widgets.dart';

class EnterIcalDialog extends EnterUrlDialog {
  final PreferencesProvider _preferencesProvider;
  final ScheduleSourceProvider _scheduleSource;

  EnterIcalDialog(this._preferencesProvider, this._scheduleSource);

  @override
  Future<String> loadUrl() {
    return _preferencesProvider.getIcalUrl();
  }

  @override
  Future saveUrl(String url) async {
    await _scheduleSource.setupForIcal(url);
  }

  @override
  bool isValidUrl(String url) {
    return IcalScheduleSource.isValidUrl(url);
  }

  @override
  String hint(BuildContext context) {
    return L.of(context).onboardingIcalUrlHint;
  }

  @override
  String message(BuildContext context) {
    return L.of(context).onboardingIcalPageDescription;
  }

  @override
  String title(BuildContext context) {
    return L.of(context).onboardingIcalPageTitle;
  }

  @override
  String invalidUrl(BuildContext context) {
    return L.of(context).onboardingRaplaUrlInvalid;
  }
}
