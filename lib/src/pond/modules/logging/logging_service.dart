import 'package:jlogical_utils/src/pond/context/module/app_module.dart';

abstract class LoggingService extends AppModule {
  void log(dynamic obj);

  void logWarning(dynamic obj);

  void logError(dynamic obj);

  void logFatal(dynamic obj);

  List<String> getLogs();
}
