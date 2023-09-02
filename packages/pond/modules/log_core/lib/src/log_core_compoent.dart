import 'package:log_core/src/console_logger_service.dart';
import 'package:log_core/src/logger_service.dart';
import 'package:pond_core/pond_core.dart';

class LogCoreComponent with IsCorePondComponent, IsLoggerServiceWrapper {
  @override
  final LoggerService loggerService;

  LogCoreComponent({required this.loggerService});

  LogCoreComponent.console() : loggerService = ConsoleLoggerService();
}
