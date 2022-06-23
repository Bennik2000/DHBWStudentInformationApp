import 'package:firebase_analytics/firebase_analytics.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

final FirebaseAnalyticsObserver rootNavigationObserver =
    FirebaseAnalyticsObserver(
  analytics: analytics,
);

final FirebaseAnalyticsObserver mainNavigationObserver =
    FirebaseAnalyticsObserver(
  analytics: analytics,
);
