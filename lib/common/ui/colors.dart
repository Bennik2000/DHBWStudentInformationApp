import 'package:flutter/material.dart';

Color colorScheduleEntryPublicHoliday(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? const Color(0xffcbcbcb)
        : const Color(0xff515151);
Color colorScheduleEntryClass(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? const Color(0xffe63f3b)
        : const Color(0xffa52632);
Color colorScheduleEntryExam(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? const Color(0xfffdb531)
        : const Color(0xffb17f22);
Color colorScheduleEntryOnline(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? const Color(0xffe63f3b)
        : const Color(0xffa52632);
Color colorScheduleEntryUnknown(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? const Color(0xffcbcbcb)
        : const Color(0xff515151);

Color colorScheduleGridGridLines(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? const Color(0xffe0e0e0)
        : const Color(0xff515151);

Color colorScheduleInPastOverlay(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? const Color(0x1F000000)
        : const Color(0x3F000000);

Color colorCurrentTimeIndicator(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? const Color(0xffffa500)
        : const Color(0xffb37300);

Color colorOnboardingDecorationForeground(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFA62828)
        : const Color(0xFFA62828);

Color colorOnboardingDecorationBackground(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFC91A1A)
        : const Color(0xFFC91A1A);

Color colorSuccess(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFC91A1A)
        : const Color(0xFFC91A1A);

Color colorDailyScheduleTimeVerticalConnector() => Colors.grey;

Color colorSeparator() => Colors.grey;

Color colorNoConnectionBackground() => Colors.black87;

Color colorNoConnectionForeground() => Colors.white;

class ColorPalettes {
  ColorPalettes._();

  static ThemeData buildTheme(bool isDark) {
    var themeData = ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      accentColor: ColorPalettes.main[500],
      primarySwatch: ColorPalettes.main,
      toggleableActiveColor:
          isDark ? ColorPalettes.main[700] : ColorPalettes.main[600],
    );

    return themeData.copyWith(
      snackBarTheme: themeData.snackBarTheme.copyWith(
        backgroundColor: isDark ? Color(0xff363635) : Color(0xfffafafa),
        contentTextStyle: themeData.textTheme.bodyText1.copyWith(
          color:
              isDark ? Color(0xffe4e4e4) : themeData.textTheme.bodyText1.color,
        ),
      ),
    );
  }

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
