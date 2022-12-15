import 'package:environment_core/src/memory_environment_config.dart';

abstract class EnvironmentConfig {
  Future<T> getOrDefault<T>(String key, {required T Function() fallback});

  static MemoryEnvironmentConfig memory({Map<String, dynamic> keyValueMap = const {}}) =>
      MemoryEnvironmentConfig(keyValueMap: keyValueMap);
}

extension EnvironmentConfigExtensions on EnvironmentConfig {
  Future<T> get<T>(String key) async {
    return await getOrDefault(key, fallback: () => throw Exception('Cannot find value for [$key] in config.'));
  }

  Future<T?> getOrNull<T>(String key) async {
    return await getOrDefault<T?>(key, fallback: () => null);
  }
}

mixin IsEnvironmentConfig implements EnvironmentConfig {}
