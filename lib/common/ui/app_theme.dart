import 'package:dhbwstudentapp/common/ui/schedule_entry_theme.dart';
import 'package:dhbwstudentapp/common/ui/schedule_theme.dart';
import 'package:dhbwstudentapp/common/ui/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  /// Light theme
  static final lightThemeData = ThemeData(
    brightness: Brightness.light,
    toggleableActiveColor: AppTheme.main[600],
    colorScheme: ColorScheme.fromSwatch(primarySwatch: main).copyWith(
      secondary: AppTheme.main[500],
      brightness: Brightness.light,
    ),
    textButtonTheme: textButtonTheme,
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xfffafafa),
    ),
    extensions: const <ThemeExtension<dynamic>>[
      scheduleEntryThemeLight,
      scheduleThemeLight,
      textTheme,
    ],
  );

  /// Dark theme
  static final darkThemeData = ThemeData(
    brightness: Brightness.dark,
    toggleableActiveColor: AppTheme.main[700],
    colorScheme: ColorScheme.fromSwatch(primarySwatch: main).copyWith(
      secondary: AppTheme.main[500],
      brightness: Brightness.dark,
    ),
    textButtonTheme: textButtonTheme,
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xff363635),
      contentTextStyle: TextStyle(
        color: Color(0xffe4e4e4),
      ),
    ),
    extensions: const <ThemeExtension<dynamic>>[
      scheduleEntryThemeDark,
      scheduleThemeDark,
      textTheme,
    ],
  );

  static final textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppTheme.main,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    ),
  );

  static const scheduleEntryThemeLight = ScheduleEntryTheme(
    unknown: Color(0xffcbcbcb),
    lesson: Color(0xffe63f3b),
    online: Color(0xffAFC7EA),
    publicHoliday: Color(0xffcbcbcb),
    exam: Color(0xfffdb531),
  );

  static const scheduleEntryThemeDark = ScheduleEntryTheme(
    unknown: Color(0xff515151),
    lesson: Color(0xffa52632),
    online: Color(0xff2659A6),
    publicHoliday: Color(0xff515151),
    exam: Color(0xffb17f22),
  );

  static const scheduleThemeLight = ScheduleTheme(
    scheduleGridGridLines: Color(0xffe0e0e0),
    scheduleInPastOverlay: Color(0x1F000000),
    currentTimeIndicator: Color(0xffffa500),
  );

  static const scheduleThemeDark = ScheduleTheme(
    scheduleGridGridLines: Color(0xff515151),
    scheduleInPastOverlay: Color(0x3F000000),
    currentTimeIndicator: Color(0xffb37300),
  );

  static const textTheme = CustomTextTheme(
    dailyScheduleEntryType: TextStyle(
      inherit: false,
      fontWeight: FontWeight.w300,
      letterSpacing: 0.15,
    ),
    dailyScheduleEntryTimeStart: TextStyle(
      inherit: false,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    scheduleEntryWidgetTitle: TextStyle(
      inherit: false,
      fontWeight: FontWeight.normal,
    ),
    scheduleEntryBottomPageType: TextStyle(
      inherit: false,
      fontWeight: FontWeight.w300,
    ),
    scheduleWidgetColumnTitleDay: TextStyle(
      inherit: false,
      fontWeight: FontWeight.w300,
    ),
  );

  static const onboardingDecorationForeground = Color(0xFFA62828);
  static const onboardingDecorationBackground = Color(0xFFC91A1A);
  static const success = Color(0xFFC91A1A);
  static const dailyScheduleTimeVerticalConnector = Colors.grey;
  static const separator = Colors.grey;
  static const noConnectionBackground = Colors.black87;
  static const noConnectionForeground = Colors.white;

  static const MaterialColor main = MaterialColor(0xffff061c, <int, Color>{
    050: Color(0xFFff838e),
    100: Color(0xFFff6a77),
    200: Color(0xFFff5160),
    300: Color(0xFFff3849),
    400: Color(0xFFff1f33),
    500: Color(0xffff061c),
    600: Color(0xFFe60519),
    700: Color(0xFFcc0516),
    800: Color(0xFFb30414),
    900: Color(0xFF990411),
  });

  static const MaterialColor secondary = MaterialColor(0xFFCECED0, <int, Color>{
    050: Color(0xFFF9F9F9),
    100: Color(0xFFF0F0F1),
    200: Color(0xFFE7E7E8),
    300: Color(0xFFDDDDDE),
    400: Color(0xFFD5D5D7),
    500: Color(0xFFCECED0),
    600: Color(0xFFC9C9CB),
    700: Color(0xFFC2C2C4),
    800: Color(0xFFBCBCBE),
    900: Color(0xFFB0B0B3),
  });

  static const MaterialColor secondaryAccent =
      MaterialColor(0xFFFFFFFF, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    700: Color(0xFFEAEAFF),
  });
}
