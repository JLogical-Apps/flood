import 'package:flutter/material.dart';
import 'package:log_core/log_core.dart';
import 'package:pond/pond.dart';

extension BuildContextLogExtensions on BuildContext {
  LogCoreComponent get logger => find<LogCoreComponent>();

  Future<void> log(message) => logger.log(message);

  Future<void> logWarning(message) => logger.logWarning(message);

  Future<void> logError(error, StackTrace stackTrace) => logger.logError(error, stackTrace);

  Future<List<String>> getLogs() => logger.getLogs();
}
