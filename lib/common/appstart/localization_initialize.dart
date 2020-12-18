import 'dart:ui';

import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:kiwi/kiwi.dart';

///
/// Initializes the localization. This ensures that the UI is displayed in the
/// correct language
///
class LocalizationInitialize {
  PreferencesProvider _preferencesProvider;
  String _languageCode;

  ///
  /// Initialize the localization using the provided language code
  ///
  LocalizationInitialize.fromLanguageCode(this._languageCode);

  ///
  /// Initialize the localization using the locale from the preferences provider
  ///
  LocalizationInitialize.fromPreferences(this._preferencesProvider);

  Future<void> setupLocalizations() async {
    var localization = L(Locale(
      _languageCode ??
          (await _preferencesProvider?.getLastUsedLanguageCode() ?? "en"),
    ));
    KiwiContainer().registerInstance(localization);
  }
}
