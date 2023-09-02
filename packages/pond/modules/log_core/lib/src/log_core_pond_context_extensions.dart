import 'package:log_core/log_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

extension LogCorePondContextExtensions on CorePondContext {
  LogCoreComponent get logger => locate<LogCoreComponent>();

  Future<void> log(message) => logger.log(message);

  Future<void> logWarning(message) => logger.logWarning(message);

  Future<void> logError(error, StackTrace stackTrace) => logger.logError(error, stackTrace);

  Future<List<String>> getLogs() => logger.getLogs();
}
