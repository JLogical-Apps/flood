import 'dart:async';

import 'package:log_core/src/logger_service.dart';

class ListenerLoggerService with IsLoggerServiceWrapper {
  @override
  final LoggerService loggerService;

  final FutureOr Function(dynamic log)? onLog;
  final FutureOr Function(dynamic log)? onLogWarning;
  final FutureOr Function(dynamic error, StackTrace stackTrace)? onLogError;

  ListenerLoggerService({
    required this.loggerService,
    this.onLog,
    this.onLogWarning,
    this.onLogError,
  });

  @override
  Future<void> log(dynamic message) async {
    await loggerService.log(message);
    await onLog?.call(message);
  }

  @override
  Future<void> logWarning(dynamic message) async {
    await loggerService.logWarning(message);
    await onLogWarning?.call(message);
  }

  @override
  Future<void> logError(dynamic error, StackTrace stackTrace) async {
    await loggerService.logError(error, stackTrace);
    await onLogError?.call(error, stackTrace);
  }
}
