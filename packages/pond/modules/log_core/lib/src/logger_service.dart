import 'dart:async';

import 'package:log_core/src/console_logger_service.dart';
import 'package:log_core/src/file_log_history_log_service.dart';
import 'package:log_core/src/listener_handler_logger_service.dart';
import 'package:log_core/src/listener_logger_service.dart';
import 'package:log_core/src/log_history.dart';
import 'package:log_core/src/log_listener.dart';
import 'package:persistence_core/persistence_core.dart';

abstract class LoggerService {
  Future<void> log(dynamic message);

  Future<void> logWarning(dynamic message);

  Future<void> logError(dynamic error, StackTrace stackTrace);

  Future<LogHistory> getLogHistory();

  Future<List<LogHistory>> getLogHistories();

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
  Future<List<String>> getLogs() async {
    final logHistory = await getLogHistory();
    return await logHistory.getLogs();
  }

  LoggerService withListenersHandler(List<LogListener> listeners) {
    return ListenerHandlerLoggerService(loggerService: this, listeners: listeners);
  }

  LoggerService withListener({
    FutureOr Function(dynamic log)? onLog,
    FutureOr Function(dynamic log)? onLogWarning,
    FutureOr Function(dynamic error, StackTrace stackTrace)? onLogError,
  }) {
    return ListenerLoggerService(
      loggerService: this,
      onLog: onLog,
      onLogWarning: onLogWarning,
      onLogError: onLogError,
    );
  }

  LoggerService withFileLogHistory(CrossDirectory logDirectory) {
    return FileLogHistoryLoggerService(loggerService: this, logDirectory: logDirectory);
  }
}

mixin IsLoggerService implements LoggerService {}

class _LoggerServiceImpl with IsLoggerService {
  final List<String> logs;
  final FutureOr<String> Function(dynamic message) onLog;
  final FutureOr<String> Function(dynamic message) onLogWarning;
  final FutureOr<String> Function(dynamic error, StackTrace stackTrace) onLogError;

  final DateTime createdTime;

  _LoggerServiceImpl({
    required this.onLog,
    required this.onLogWarning,
    required this.onLogError,
  })  : logs = [],
        createdTime = DateTime.now();

  @override
  Future<LogHistory> getLogHistory() async {
    return LogHistory(
      logs: logs,
      timeCreated: createdTime,
    );
  }

  @override
  Future<List<LogHistory>> getLogHistories() async {
    return [await getLogHistory()];
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
  Future<LogHistory> getLogHistory() => loggerService.getLogHistory();

  @override
  Future<List<LogHistory>> getLogHistories() => loggerService.getLogHistories();
}
