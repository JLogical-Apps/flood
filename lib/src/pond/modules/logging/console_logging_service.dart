import 'package:colorize_lumberdash/colorize_lumberdash.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:lumberdash/lumberdash.dart' as lumberdash;

import 'logging_service.dart';

class ConsoleLoggingService extends LoggingService {
  final List<String> logHistory = [];

  @override
  void onRegister(AppRegistration registration) {
    lumberdash.putLumberdashToWork(withClients: [
      ColorizeLumberdash(),
    ]);
  }

  @override
  void log(obj) {
    final message = '$obj';
    lumberdash.logMessage(message);
    logHistory.add(message);
  }

  @override
  void logWarning(obj) {
    final message = '$obj';
    lumberdash.logWarning(message);
    logHistory.add(message);
  }

  @override
  void logError(obj) {
    final message = '$obj';
    lumberdash.logError(message);
    logHistory.add(message);
  }

  @override
  void logFatal(obj) {
    final message = '$obj';
    lumberdash.logFatal(message);
    logHistory.add(message);
  }

  @override
  List<String> getLogs() {
    return logHistory;
  }
}
