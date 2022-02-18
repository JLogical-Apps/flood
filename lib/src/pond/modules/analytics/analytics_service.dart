import 'package:jlogical_utils/jlogical_utils.dart';

import 'analytics_event.dart';

abstract class AnalyticsService extends AppModule {
  Future<void> logEvent(AnalyticsEvent event);

  Future<void> logScreenChange(String screenName);
}
