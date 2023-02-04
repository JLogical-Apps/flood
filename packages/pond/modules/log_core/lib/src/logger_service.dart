import 'dart:async';

abstract class LoggerService {
  Future<void> log(dynamic message);

  Future<void> logWarning(dynamic message);

  Future<void> logError(dynamic error, StackTrace stackTrace);

  Future<String> getLogs();

  factory LoggerService({
    required FutureOr<String> Function(dynamic message) onLog,
    required FutureOr<String> Function(dynamic message) onLogWarning,
    required FutureOr<String> Function(dynamic error, StackTrace stackTrace) onLogError,
  }) {
    return _LoggerServiceImpl(onLog: onLog, onLogWarning: onLogWarning, onLogError: onLogError);
  }
}

mixin IsLoggerService implements LoggerService {}

class _LoggerServiceImpl with IsLoggerService {
  final List<String> logs;
  final FutureOr<String> Function(dynamic message) onLog;
  final FutureOr<String> Function(dynamic message) onLogWarning;
  final FutureOr<String> Function(dynamic error, StackTrace stackTrace) onLogError;

  _LoggerServiceImpl({
    required this.onLog,
    required this.onLogWarning,
    required this.onLogError,
  }) : logs = [];

  @override
  Future<String> getLogs() async {
    return logs.join('\n');
  }

  @override
  Future<void> log(message) async {
    final messageText = await onLog(message);
    logs.add(messageText);
  }

  @override
  Future<void> logWarning(message) async {
    final messageText = await onLogWarning(message);
    logs.add(messageText);
  }

  @override
  Future<void> logError(error, StackTrace stackTrace) async {
    final messageText = await onLogError(error, stackTrace);
    logs.add(messageText);
  }
}

abstract class LoggerServiceWrapper implements LoggerService {
  LoggerService get loggerService;
}

mixin IsLoggerServiceWrapper implements LoggerServiceWrapper {
  @override
  Future<void> log(message) => loggerService.log(message);

  @override
  Future<void> logWarning(message) => loggerService.logWarning(message);

  @override
  Future<void> logError(error, StackTrace stackTrace) => loggerService.logError(error, stackTrace);

  @override
  Future<String> getLogs() => loggerService.getLogs();
}
