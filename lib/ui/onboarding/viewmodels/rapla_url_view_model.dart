import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:dhbwstudentapp/schedule/service/rapla/rapla_schedule_source.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model_base.dart';
import 'package:flutter/services.dart';

class RaplaUrlViewModel extends OnboardingStepViewModel {
  final PreferencesProvider preferencesProvider;
  final ScheduleSourceProvider scheduleSourceProvider;

  String? _raplaUrl;
  String? get raplaUrl => _raplaUrl;

  bool urlHasError = false;

  RaplaUrlViewModel(
    this.preferencesProvider,
    this.scheduleSourceProvider,
  );

  void setRaplaUrl(String? url) {
    _raplaUrl = url;

    notifyListeners("raplaUrl");

    _validateUrl();
  }

  void _validateUrl() {
    urlHasError = !RaplaScheduleSource.isValidUrl(_raplaUrl!);

    isValid = !urlHasError;

    notifyListeners("urlHasError");
  }

  Future<void> pasteUrl() async {
    final ClipboardData? data = await Clipboard.getData('text/plain');

    if (data?.text != null) {
      setRaplaUrl(data!.text);
    }
  }

  @override
  Future<void> save() async {
    await scheduleSourceProvider.setupForRapla(_raplaUrl);
  }
}
