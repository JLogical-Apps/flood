import '../../context/app_context.dart';
import '../../context/module/app_module.dart';
import '../config/config_module.dart';
import 'environment.dart';

class EnvironmentModule extends AppModule {
  late final Environment environment;

  EnvironmentModule._();

  EnvironmentModule.createForTesting() {
    environment = Environment.testing;
  }

  static Future<EnvironmentModule> create() async {
    final module = EnvironmentModule._();
    module.environment = await _getEnvironment();
    return module;
  }

  static Future<Environment> _getEnvironment() async {
    if (AppContext.global.isRelease) {
      return Environment.production;
    }

    final configEnvironment = await locateOrNull<ConfigModule>()?.getEnvironmentFromConfig();
    if (configEnvironment != null) {
      return configEnvironment;
    }

    return Environment.testing;
  }
}

extension AppContextEnvironmentExtension on AppContext {
  Environment get environment => locate<EnvironmentModule>().environment;

  Environment? get environmentOrNull => locateOrNull<EnvironmentModule>()?.environment;
}
