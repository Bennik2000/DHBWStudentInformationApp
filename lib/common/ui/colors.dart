import 'package:flutter/material.dart';

Color colorScheduleEntryPublicHoliday(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? const Color(0xffcbcbcb)
        : const Color(0xff515151);
Color colorScheduleEntryClass(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? const Color(0xffff2137)
        : const Color(0xffa52632);
Color colorScheduleEntryExam(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? const Color(0xffffe000)
        : const Color(0xffb39d00);
Color colorScheduleEntryOnline(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? const Color(0xffff2137)
        : const Color(0xffa52632);
Color colorScheduleEntryUnknown(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? const Color(0xffcbcbcb)
        : const Color(0xff515151);

Color colorScheduleGridGridLines(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? const Color(0xffe0e0e0)
        : const Color(0xff515151);

Color colorCurrentTimeIndicator(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? const Color(0xffffa500)
        : const Color(0xffb37300);

Color colorDailyScheduleTimeVerticalConnector() => Colors.grey;
Color colorSeparator() => Colors.grey;

Color colorNoConnectionBackground() => Colors.black87;

class ColorPalettes {
  ColorPalettes._();

  static const MaterialColor main = MaterialColor(0xffff061c, <int, Color>{
    050: const Color(0xFFff838e),
    100: const Color(0xFFff6a77),
    200: const Color(0xFFff5160),
    300: const Color(0xFFff3849),
    400: const Color(0xFFff1f33),
    500: const Color(0xffff061c),
    600: const Color(0xFFe60519),
    700: const Color(0xFFcc0516),
    800: const Color(0xFFb30414),
    900: const Color(0xFF990411),
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
