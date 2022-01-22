import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/environment/environment.dart';
import 'package:jlogical_utils/src/pond/context/module/app_module.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/modules/logging/console_logging_service.dart';
import 'package:jlogical_utils/src/pond/modules/logging/logging_service.dart';

class DefaultLoggingModule extends AppModule {
  @override
  void onRegister(AppRegistration registration) {
    registration.register<LoggingService>(_getLoggingService(registration.environment));
  }

  LoggingService _getLoggingService(Environment environment) {
    switch (environment) {
      case Environment.testing:
      case Environment.device:
        return ConsoleLoggingService();
      default:
        throw UnimplementedError();
    }
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
