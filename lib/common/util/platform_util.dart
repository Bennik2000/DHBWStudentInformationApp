import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PlatformUtil {
  static bool isPhone() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600;
  }

  static bool isTablet() {
    return !isPhone();
  }

  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static Brightness platformBrightness() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.platformBrightness ?? Brightness.light;
  }

  static void initializePortraitLandscapeMode() {
    if (isPhone()) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  static bool isAndroid() {
    return Platform.isAndroid;
  }
}
