import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:dhbwstudentapp/schedule/service/ical/ical_schedule_source.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model_base.dart';
import 'package:flutter/services.dart';

class IcalUrlViewModel extends OnboardingStepViewModel {
  final PreferencesProvider preferencesProvider;
  final ScheduleSourceProvider scheduleSourceProvider;

  String? _url;
  String? get url => _url;

  bool urlHasError = false;

  IcalUrlViewModel(this.preferencesProvider, this.scheduleSourceProvider);

  void setUrl(String? url) {
    _url = url;

    notifyListeners("url");

    _validateUrl();
  }

  void _validateUrl() {
    urlHasError = !IcalScheduleSource.isValidUrl(_url!);

    setIsValid(!urlHasError);

    notifyListeners("urlHasError");
  }

  Future<void> pasteUrl() async {
    final ClipboardData? data = await Clipboard.getData('text/plain');

    if (data?.text != null) {
      setUrl(data!.text);
    }
  }

  @override
  Future<void> save() async {
    await scheduleSourceProvider.setupForIcal(_url);
  }
}
