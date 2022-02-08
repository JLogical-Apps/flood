import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/module/app_module.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/modules/environment/environment_module.dart';
import 'package:jlogical_utils/src/pond/modules/logging/console_logging_service.dart';
import 'package:jlogical_utils/src/pond/modules/logging/logging_service.dart';

import '../environment/environment.dart';

class DefaultLoggingModule extends AppModule {
  @override
  void onRegister(AppRegistration registration) {
    registration.register<LoggingService>(_getLoggingService(AppContext.global.environment));
  }

  LoggingService _getLoggingService(Environment environment) {
    return ConsoleLoggingService();
  }
}

void log(dynamic obj) {
  locate<LoggingService>().log(obj);
}

void logWarning(dynamic obj) {
  locate<LoggingService>().log(obj);
}

void logError(dynamic obj) {
  locate<LoggingService>().log(obj);
}

void logFatal(dynamic obj) {
  locate<LoggingService>().log(obj);
}
