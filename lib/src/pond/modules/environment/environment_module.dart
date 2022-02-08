import 'package:jlogical_utils/jlogical_utils.dart';

import 'environment.dart';

class EnvironmentModule extends AppModule {
  late final Environment environment;

  EnvironmentModule._();

  static Future<EnvironmentModule> create() async {
    final module = EnvironmentModule._();
    module.environment = await locate<ConfigModule>().getEnvironmentFromConfig();
    return module;
  }
}

extension AppContextEnvironmentExtension on AppContext {
  Environment get environment => locate<EnvironmentModule>().environment;
}
