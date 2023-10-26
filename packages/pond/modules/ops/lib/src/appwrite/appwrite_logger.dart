import 'package:log_core/log_core.dart';

extension AppwriteLoggerStaticExtensions on LoggerServiceStatic {
  LoggerService appwrite(dynamic context) {
    return LoggerService(
      onLog: (message) {
        message = '$message';
        context.log(message);
        return message;
      },
      onLogWarning: (message) {
        message = '[WARNING] $message';
        context.log(message);
        return message;
      },
      onLogError: (error, stackTrace) {
        final message = '[ERROR] $error\n$stackTrace';
        context.log(message);
        return message;
      },
    );
  }
}
