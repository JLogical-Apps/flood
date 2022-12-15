import 'package:environment_core/src/environment_config.dart';

class CollapsedEnvironmentConfig with IsEnvironmentConfig {
  final List<EnvironmentConfig> configs;

  CollapsedEnvironmentConfig({required this.configs});

  @override
  Future<T> getOrDefault<T>(String key, {required T Function() fallback}) async {
    for (final config in configs) {
      if (await config.containsKey(key)) {
        return await config.get(key);
      }
    }
    return fallback();
  }
}
