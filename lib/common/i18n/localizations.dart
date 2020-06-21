import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'localization_strings.dart';

class L {
  final Locale locale;
  String _language;

  L(this.locale) {
    _language = locale?.languageCode?.substring(0, 2);

    if (!_localizedValues.containsKey(_language)) {
      _language = "en";
    }
  }

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
  String get notificationNextClassNoNextClassMessage =>
      _getValue("notificationNextClassNoNextClassMessage");
  String get notificationNextClassNextClassAtMessage =>
      _getValue("notificationNextClassNextClassAtMessage");
  String get notificationNextClassTomorrow =>
      _getValue("notificationNextClassTomorrow");
  String get notificationNextClassTitle =>
      _getValue("notificationNextClassTitle");
  String get disclaimer => _getValue("disclaimer");
  String get notificationScheduleChangedNewClass =>
      _getValue("notificationScheduleChangedNewClass");
  String get notificationScheduleChangedNewClassTitle =>
      _getValue("notificationScheduleChangedNewClassTitle");
  String get notificationScheduleChangedRemovedClass =>
      _getValue("notificationScheduleChangedRemovedClass");
  String get notificationScheduleChangedRemovedClassTitle =>
      _getValue("notificationScheduleChangedRemovedClassTitle");
  String get notificationScheduleChangedClass =>
      _getValue("notificationScheduleChangedClass");
  String get notificationScheduleChangedClassTitle =>
      _getValue("notificationScheduleChangedClassTitle");

  String get informationPageDHBWHomepage =>
      _getValue("informationPageDHBWHomepage");
  String get informationPageDualis => _getValue("informationPageDualis");
  String get informationPageRoundcube => _getValue("informationPageRoundcube");
  String get informationPageMoodle => _getValue("informationPageMoodle");
  String get informationPageLocation => _getValue("informationPageLocation");
  String get informationPageEduroam => _getValue("informationPageEduroam");
  String get informationPageStuV => _getValue("informationPageStuV");
  String get informationPageDHBWSports =>
      _getValue("informationPageDHBWSports");

  static L of(BuildContext context) {
    return Localizations.of<L>(context, L);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    "de": de,
    "en": en
  };

  _getValue(String key) {
    return _localizedValues[_language][key] ?? "";
  }

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
