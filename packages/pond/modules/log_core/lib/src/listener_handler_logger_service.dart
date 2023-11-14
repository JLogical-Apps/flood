import 'package:log_core/src/log_listener.dart';
import 'package:log_core/src/logger_service.dart';
import 'package:utils_core/utils_core.dart';

class ListenerHandlerLoggerService with IsLoggerServiceWrapper {
  @override
  final LoggerService loggerService;

  final List<LogListener> listeners;

  ListenerHandlerLoggerService({required this.loggerService, required this.listeners});

  @override
  Future<void> log(dynamic message) async {
    await loggerService.log(message);
    for (final listener in listeners) {
      await guardAsync(
        () => listener.log(message),
        onException: (error, stackTrace) => loggerService.logError(error, stackTrace),
      );
    }
  }

  @override
  Future<void> logWarning(dynamic message) async {
    await loggerService.logWarning(message);
    for (final listener in listeners) {
      await guardAsync(
        () => listener.logWarning(message),
        onException: (error, stackTrace) => loggerService.logError(error, stackTrace),
      );
    }
  }

  @override
  Future<void> logError(dynamic error, StackTrace stackTrace) async {
    await loggerService.logError(error, stackTrace);
    for (final listener in listeners) {
      await guardAsync(
        () => listener.logError(error, stackTrace),
        onException: (error, stackTrace) => loggerService.logError(error, stackTrace),
      );
    }
  }
}
