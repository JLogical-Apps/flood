import 'package:log_core/src/logger_service.dart';

class ConsoleLoggerService with IsLoggerServiceWrapper {
  @override
  late final LoggerService loggerService = LoggerService(
    onLog: (message) => '$message',
    onLogWarning: (message) => '[WARNING] $message',
    onLogError: (error, stackTrace) => '[ERROR] $error\n$stackTrace',
  );
}
