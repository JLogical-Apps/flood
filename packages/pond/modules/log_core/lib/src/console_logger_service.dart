import 'package:log_core/src/logger_service.dart';

class ConsoleLoggerService with IsLoggerServiceWrapper {
  @override
  late final LoggerService loggerService = LoggerService(
    onLog: (message) {
      message = '$message';
      print(message);
      return message;
    },
    onLogWarning: (message) {
      message = '[WARNING] $message';
      print(message);
      return message;
    },
    onLogError: (error, stackTrace) {
      final message = '[ERROR] $error\n$stackTrace';
      print(message);
      return message;
    },
  );
}
