import 'package:jlogical_utils/src/pond/modules/analytics/firebase_analytics_service.dart';
import 'package:jlogical_utils/src/pond/modules/environment/default_environment_data.dart';
import 'package:jlogical_utils/src/pond/modules/environment/environment_data_source.dart';
import 'package:jlogical_utils/src/pond/modules/environment/environment_module.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../context/app_context.dart';
import '../../context/module/app_module.dart';
import '../../context/registration/app_registration.dart';
import 'analytics_event.dart';
import 'analytics_service.dart';

class DefaultAnalyticsModule extends AppModule {
  @override
  void onRegister(AppRegistration registration) {
    _getService(DefaultEnvironmentData.getDataSource(AppContext.global.environment))
        .mapIfNonNull((service) => registration.register<AnalyticsService>(service));
  }

  AnalyticsService? _getService(EnvironmentDataSource dataSource) {
    if (dataSource == EnvironmentDataSource.online) {
      return FirebaseAnalyticsService();
    }

    return null;
  }
}

Future<void> logEvent(AnalyticsEvent event) async {
  await locateOrNull<AnalyticsService>()?.logEvent(event);
}

Future<void> logScreenChange(String screenName) async {
  await locateOrNull<AnalyticsService>()?.logScreenChange(screenName);
}
