import 'dart:async';

import 'package:log_core/src/console_logger_service.dart';
import 'package:log_core/src/listener_handler_logger_service.dart';
import 'package:log_core/src/log_listener.dart';

abstract class LoggerService {
  Future<void> log(dynamic message);

  Future<void> logWarning(dynamic message);

  Future<void> logError(dynamic error, StackTrace stackTrace);

  Future<List<String>> getLogs();

  factory LoggerService({
    required FutureOr<String> Function(dynamic message) onLog,
    required FutureOr<String> Function(dynamic message) onLogWarning,
    required FutureOr<String> Function(dynamic error, StackTrace stackTrace) onLogError,
  }) {
    return _LoggerServiceImpl(onLog: onLog, onLogWarning: onLogWarning, onLogError: onLogError);
  }

  static final LoggerServiceStatic static = LoggerServiceStatic();
}

class LoggerServiceStatic {
  LoggerService get console => ConsoleLoggerService();
}

extension LoggerServiceExtensions on LoggerService {
  LoggerService withListenersHandler(List<LogListener> listeners) {
    return ListenerHandlerLoggerService(loggerService: this, listeners: listeners);
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
  Future<List<String>> getLogs() async {
    return logs;
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
  Future<List<String>> getLogs() => loggerService.getLogs();
}
