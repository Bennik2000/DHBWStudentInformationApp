import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'localization_strings.dart';

class L {
  final Locale locale;

  L(this.locale);

  String get scheduleEntryDetailFrom => _getValue("scheduleEntryDetailFrom");
  String get scheduleEntryDetailTo => _getValue("scheduleEntryDetailTo");
  String get pageDayOverviewTitle => _getValue("pageDayOverviewTitle");
  String get pageWeekOverviewTitle => _getValue("pageWeekOverviewTitle");
  String get noConnectionMessage => _getValue("noConnectionMessage");
  String get settingsViewSourceCode => _getValue("settingsViewSourceCode");
  String get applicationName => _getValue("applicationName");
  String get applicationLegalese => _getValue("applicationLegalese");
  String get settingsAbout => _getValue("settingsAbout");
  String get settingsAboutTitle => _getValue("settingsAboutTitle");
  String get settingsDarkMode => _getValue("settingsDarkMode");
  String get settingsDesign => _getValue("settingsDesign");
  String get settingsScheduleSourceUrl =>
      _getValue("settingsScheduleSourceUrl");
  String get settingsScheduleSourceTitle =>
      _getValue("settingsScheduleSourceTitle");
  String get settingsPageTitle => _getValue("settingsPageTitle");
  String get onboardingTitle => _getValue("onboardingTitle");
  String get onboardingSourceUrlInput => _getValue("onboardingSourceUrlInput");
  String get onboardingSourceUrlInvalid =>
      _getValue("onboardingSourceUrlInvalid");
  String get onboardingSourceUrlHint => _getValue("onboardingSourceUrlHint");
  String get onboardingSourceUrlPaste => _getValue("onboardingSourceUrlPaste");
  String get onboardingFinishButton => _getValue("onboardingFinishButton");
  String get dailyScheduleNoEntriesToday =>
      _getValue("dailyScheduleNoEntriesToday");
  String get scheduleEntryTypePublicHoliday =>
      _getValue("scheduleEntryTypePublicHoliday");
  String get scheduleEntryTypeClass => _getValue("scheduleEntryTypeClass");
  String get scheduleEntryTypeExam => _getValue("scheduleEntryTypeExam");
  String get scheduleEntryTypeOnline => _getValue("scheduleEntryTypeOnline");
  String get scheduleEntryTypeUnknown => _getValue("scheduleEntryTypeUnknown");

  static L of(BuildContext context) {
    return Localizations.of<L>(context, L);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    "de": de,
    "en": en
  };

  _getValue(String key) => _localizedValues[locale.languageCode][key] ?? "";

  String getValue(String key) => _getValue(key);
}

class LocalizationDelegate extends LocalizationsDelegate<L> {
  const LocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['de', 'en'].contains(locale.languageCode);

  @override
  Future<L> load(Locale locale) {
    return SynchronousFuture<L>(L(locale));
  }

  @override
  bool shouldReload(LocalizationDelegate old) => false;
}
