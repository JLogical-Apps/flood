import 'package:emoji_lumberdash/emoji_lumberdash.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/modules/logging/logging_service.dart';
import 'package:lumberdash/lumberdash.dart' as lumberdash;

class ConsoleLoggingService extends LoggingService {
  void onRegister(AppRegistration registration) {
    lumberdash.putLumberdashToWork(withClients: [
      EmojiLumberdash(
        methodCount: 0,
        lineLength: 50,
        printTime: true,
        errorMethodCount: 25,
        printEmoji: true,
        printBox: true,
        printColors: true,
      ),
    ]);
  }

  @override
  void log(obj) {
    lumberdash.logMessage('$obj');
  }

  @override
  void logWarning(obj) {
    lumberdash.logWarning('$obj');
  }

  @override
  void logError(obj) {
    lumberdash.logError('$obj');
  }

  @override
  void logFatal(obj) {
    lumberdash.logFatal('$obj');
  }
}
