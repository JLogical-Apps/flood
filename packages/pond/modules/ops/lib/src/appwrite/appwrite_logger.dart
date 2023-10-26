import 'package:log_core/log_core.dart';

extension AppwriteLoggerStaticExtensions on LoggerServiceStatic {
  LoggerService appwrite(dynamic context) {
    return LoggerService(
      onLog: (message) => context.log('$message'),
      onLogWarning: (message) => context.log('[WARNING] $message'),
      onLogError: (error, stackTrace) => context.error('$error\n$stackTrace'),
    );
  }
}
