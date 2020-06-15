import 'dart:ui';

import 'package:dhbwstuttgart/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstuttgart/common/i18n/localizations.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class LocalizationInitialize {
  PreferencesProvider _preferencesProvider;
  String _languageCode;

  LocalizationInitialize.fromLanguageCode(this._languageCode);
  LocalizationInitialize.fromPreferences(this._preferencesProvider);

  Future<void> setupLocalizations() async {
    var localization = L(Locale(
      _languageCode ??
          (await _preferencesProvider?.getLastUsedLanguageCode() ?? "en"),
    ));
    kiwi.Container().registerInstance(localization);
  }
}
