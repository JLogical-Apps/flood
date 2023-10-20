import 'dart:async';

class LogListener {
  final FutureOr Function(dynamic log)? onLog;
  final FutureOr Function(dynamic log)? onLogWarning;
  final FutureOr Function(dynamic error, StackTrace stackTrace)? onLogError;

  LogListener({this.onLog, this.onLogWarning, this.onLogError});

  Future<void> log(dynamic log) async {
    await onLog?.call(log);
  }

  Future<void> logWarning(dynamic warning) async {
    await onLogWarning?.call(warning);
  }

  Future<void> logError(dynamic error, StackTrace stackTrace) async {
    await onLogError?.call(error, stackTrace);
  }
}
