import 'package:flutter/foundation.dart';

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
    module.environment =
        kReleaseMode ? Environment.production : await locate<ConfigModule>().getEnvironmentFromConfig();
    return module;
  }
}

extension AppContextEnvironmentExtension on AppContext {
  Environment get environment => locate<EnvironmentModule>().environment;

  Environment? get environmentOrNull => locateOrNull<EnvironmentModule>()?.environment;
}
