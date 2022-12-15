import 'dart:async';

import 'package:environment_core/src/collapsed_environment_config.dart';
import 'package:environment_core/src/memory_environment_config.dart';

abstract class EnvironmentConfig {
  FutureOr<T> getOrDefault<T>(String key, {required T Function() fallback});

  FutureOr<bool> containsKey(String key);

  static MemoryEnvironmentConfig memory([Map<String, dynamic> keyValueMap = const {}]) =>
      MemoryEnvironmentConfig(keyValueMap: keyValueMap);

  static CollapsedEnvironmentConfig collapsed(List<EnvironmentConfig> configs) =>
      CollapsedEnvironmentConfig(configs: configs);
}

extension EnvironmentConfigExtensions on EnvironmentConfig {
  Future<T> get<T>(String key) async {
    return await getOrDefault(key, fallback: () => throw Exception('Cannot find value for [$key] in config.'));
  }

  Future<T?> getOrNull<T>(String key) async {
    return await getOrDefault<T?>(key, fallback: () => null);
  }
}

mixin IsEnvironmentConfig implements EnvironmentConfig {
  @override
  FutureOr<bool> containsKey(String key) async {
    return await getOrNull(key) != null;
  }
}
