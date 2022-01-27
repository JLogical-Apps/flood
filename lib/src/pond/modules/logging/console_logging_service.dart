import 'package:colorize_lumberdash/colorize_lumberdash.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/modules/logging/logging_service.dart';
import 'package:lumberdash/lumberdash.dart' as lumberdash;

class ConsoleLoggingService extends LoggingService {
  void onRegister(AppRegistration registration) {
    lumberdash.putLumberdashToWork(withClients: [
      ColorizeLumberdash(),
    ]);
  }

  @override
  void log(obj) {
    lumberdash.logMessage('$obj');
  }

  @override
  void logWarning(obj) {
    lumberdash.logWarning('$obj');
  }

  @override
  void logError(obj) {
    lumberdash.logError('$obj');
  }

  @override
  void logFatal(obj) {
    lumberdash.logFatal('$obj');
  }
}
