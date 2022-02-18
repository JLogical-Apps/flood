import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'analytics_event.dart';
import 'analytics_service.dart';

class FirebaseAnalyticsService extends AnalyticsService {
  late final analytics = FirebaseAnalytics.instance;

  @override
  List<NavigatorObserver> get navigatorObservers => [
        FirebaseAnalyticsObserver(analytics: analytics),
      ];

  @override
  Future<void> logEvent(AnalyticsEvent event) async {
    analytics.logEvent(name: event.name, parameters: event.parameters);
  }

  @override
  Future<void> logScreenChange(String screenName) async {
    analytics.setCurrentScreen(screenName: screenName);
  }
}
