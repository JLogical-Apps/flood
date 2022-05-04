import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/module/app_module.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/modules/environment/environment_module.dart';
import 'package:jlogical_utils/src/pond/modules/logging/console_logging_service.dart';
import 'package:jlogical_utils/src/pond/modules/logging/logging_service.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../environment/environment.dart';

class DefaultLoggingModule extends AppModule {
  late LoggingService _loggingService = _getLoggingService(AppContext.global.environment);

  @override
  void onRegister(AppRegistration registration) {
    registration.register<LoggingService>(_loggingService);
  }

  LoggingService _getLoggingService(Environment environment) {
    return ConsoleLoggingService();
  }

  Future<File> getLogFile() async {
    final logFile = AppContext.global.supportDirectory / 'logs' - 'logs-${DateTime.now()}';
    await logFile.ensureCreated();
    debugPrint(_loggingService.getLogs().join('\n'));
    await logFile.writeAsString(_loggingService.getLogs().join('\n'));

    return logFile;
  }
}

void log(dynamic obj) {
  locate<LoggingService>().log(obj);
}

void logWarning(dynamic obj) {
  locate<LoggingService>().log(obj);
}

void logError(dynamic obj) {
  locate<LoggingService>().log(obj);
}

void logFatal(dynamic obj) {
  locate<LoggingService>().log(obj);
}
