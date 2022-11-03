import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:dhbwstudentapp/schedule/service/rapla/rapla_schedule_source.dart';
import 'package:dhbwstudentapp/schedule/ui/widgets/enter_url_dialog.dart';
import 'package:flutter/material.dart';

///
/// Shows a dialog to enter and validate the url for rapla
///
class EnterRaplaUrlDialog extends EnterUrlDialog {
  final PreferencesProvider _preferencesProvider;
  final ScheduleSourceProvider _scheduleSource;

  EnterRaplaUrlDialog(this._preferencesProvider, this._scheduleSource);

  @override
  Future saveUrl(String? url) async {
    await _scheduleSource.setupForRapla(url);
  }

  @override
  Future<String> loadUrl() async {
    return await _preferencesProvider.getRaplaUrl();
  }

  @override
  bool isValidUrl(String? url) {
    return RaplaScheduleSource.isValidUrl(url!);
  }

  @override
  String hint(BuildContext context) {
    return L.of(context).onboardingRaplaUrlHint;
  }

  @override
  String message(BuildContext context) {
    return L.of(context).onboardingRaplaPageDescription;
  }

  @override
  String title(BuildContext context) {
    return L.of(context).dialogSetRaplaUrlTitle;
  }

  @override
  String invalidUrl(BuildContext context) {
    return L.of(context).onboardingRaplaUrlInvalid;
  }
}
