import 'dart:ui';

import 'package:dhbwstuttgart/common/i18n/localizations.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class LocalizationInitialize {
  void setupLocalizations(String languageCode) {
    var localization = L(Locale(languageCode));
    kiwi.Container().registerInstance(localization);
  }
}
