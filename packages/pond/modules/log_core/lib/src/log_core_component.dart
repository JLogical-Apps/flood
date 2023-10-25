import 'dart:async';

import 'package:log_core/src/log_listener.dart';
import 'package:log_core/src/logger_service.dart';
import 'package:pond_core/pond_core.dart';

class LogCoreComponent with IsCorePondComponent, IsLoggerServiceWrapper {
  @override
  final LoggerService loggerService;

  final List<LogListener> listeners;

  LogCoreComponent._({required this.loggerService, required this.listeners});

  factory LogCoreComponent({required LoggerService loggerService}) {
    final listeners = <LogListener>[];
    return LogCoreComponent._(loggerService: loggerService.withListenersHandler(listeners), listeners: listeners);
  }

  void addListener({
    FutureOr Function(dynamic log)? onLog,
    FutureOr Function(dynamic log)? onLogWarning,
    FutureOr Function(dynamic error, StackTrace stackTrace)? onLogError,
  }) {
    listeners.add(LogListener(
      onLog: onLog,
      onLogWarning: onLogWarning,
      onLogError: onLogError,
    ));
  }
}
