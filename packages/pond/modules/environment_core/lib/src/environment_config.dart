import 'dart:async';
import 'dart:io';

import 'package:environment_core/src/collapsed_environment_config.dart';
import 'package:environment_core/src/data_source_environment_config.dart';
import 'package:environment_core/src/file_environment_config.dart';
import 'package:environment_core/src/memory_environment_config.dart';
import 'package:persistence_core/persistence_core.dart';

abstract class EnvironmentConfig {
  FutureOr<T> getOrDefault<T>(String key, {required T Function() fallback});

  FutureOr<bool> containsKey(String key);

  static DataSourceEnvironmentConfig fromDataSource(DataSource<Map<String, dynamic>> dataSource) =>
      DataSourceEnvironmentConfig(dataSource: dataSource);

  static MemoryEnvironmentConfig memory([Map<String, dynamic> initialData = const {}]) =>
      MemoryEnvironmentConfig(initialData: initialData);

  static FileEnvironmentConfig file(File file) => FileEnvironmentConfig(file: file);

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

abstract class EnvironmentConfigWrapper implements EnvironmentConfig {
  EnvironmentConfig get environmentConfig;
}

mixin IsEnvironmentConfigWrapper implements EnvironmentConfigWrapper {
  @override
  FutureOr<T> getOrDefault<T>(String key, {required T Function() fallback}) {
    return environmentConfig.getOrDefault<T>(key, fallback: fallback);
  }

  @override
  FutureOr<bool> containsKey(String key) {
    return environmentConfig.containsKey(key);
  }
}
