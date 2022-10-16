import 'dart:ui';

import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:kiwi/kiwi.dart';

///
/// Initializes the localization. This ensures that the UI is displayed in the
/// correct language
///
class LocalizationInitialize {
  final PreferencesProvider? _preferencesProvider;
  final String? _languageCode;

  ///
  /// Initialize the localization using the provided language code
  ///
  const LocalizationInitialize.fromLanguageCode(this._languageCode)
      : _preferencesProvider = null;

  ///
  /// Initialize the localization using the locale from the preferences provider
  ///
  const LocalizationInitialize.fromPreferences(this._preferencesProvider)
      : _languageCode = null;

  Future<void> setupLocalizations() async {
    final localization = L(
      Locale(
        _languageCode ??
            (await _preferencesProvider?.getLastUsedLanguageCode() ?? "en"),
      ),
    );
    KiwiContainer().registerInstance(localization);
  }
}
