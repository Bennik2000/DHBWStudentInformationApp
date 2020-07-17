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

  String get settingsNotificationsTitle =>
      _getValue("settingsNotificationsTitle");
  String get settingsNotificationsNextDay =>
      _getValue("settingsNotificationsNextDay");
  String get settingsNotificationsScheduleChange =>
      _getValue("settingsNotificationsScheduleChange");

  String get screenScheduleTitle => _getValue("screenScheduleTitle");
  String get screenUsefulLinks => _getValue("screenUsefulLinks");

  String get dualisExamResultsExamColumnHeader =>
      _getValue("dualisExamResultsExamColumnHeader");
  String get dualisExamResultsCreditsColumnHeader =>
      _getValue("dualisExamResultsCreditsColumnHeader");
  String get dualisExamResultsGradeColumnHeader =>
      _getValue("dualisExamResultsGradeColumnHeader");
  String get dualisOverviewPassedColumnHeader =>
      _getValue("dualisOverviewPassedColumnHeader");
  String get dualisExamResultsSemesterSelect =>
      _getValue("dualisExamResultsSemesterSelect");
  String get dualisExamResultsTitle => _getValue("dualisExamResultsTitle");
  String get dualisOverviewGradeColumnHeader =>
      _getValue("dualisOverviewGradeColumnHeader");
  String get dualisOverviewCreditsColumnHeader =>
      _getValue("dualisOverviewCreditsColumnHeader");
  String get dualisOverviewModuleColumnHeader =>
      _getValue("dualisOverviewModuleColumnHeader");
  String get dualisOverviewModuleGrades =>
      _getValue("dualisOverviewModuleGrades");
  String get dualisOverviewCredits => _getValue("dualisOverviewCredits");
  String get dualisOverviewGpaMainModules =>
      _getValue("dualisOverviewGpaMainModules");
  String get dualisOverviewGpaTotalModules =>
      _getValue("dualisOverviewGpaTotalModules");

  String get dualisOverview => _getValue("dualisOverview");
  String get screenDualisTitle => _getValue("screenDualisTitle");
  String get pageDualisExams => _getValue("pageDualisExams");
  String get pageDualisOverview => _getValue("pageDualisOverview");
  String get dualisLoginFailed => _getValue("dualisLoginFailed");
  String get dualisLogin => _getValue("dualisLogin");
  String get loginUsername => _getValue("loginUsername");
  String get loginPassword => _getValue("loginPassword");
  String get loginButton => _getValue("loginButton");

  String get rateDialogRateNowButton => _getValue("rateDialogRateNowButton");
  String get rateDialogRateLaterButton =>
      _getValue("rateDialogRateLaterButton");
  String get rateDialogDoNotRateButton =>
      _getValue("rateDialogDoNotRateButton");
  String get rateDialogMessage => _getValue("rateDialogMessage");
  String get rateDialogTitle => _getValue("rateDialogTitle");

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
