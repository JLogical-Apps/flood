import 'dart:async';

import 'package:environment_core/src/environment_config.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:utils_core/utils_core.dart';

class DataSourceEnvironmentConfig implements EnvironmentConfig {
  final DataSource<Map<String, dynamic>> dataSource;

  DataSourceEnvironmentConfig({required this.dataSource});

  @override
  FutureOr<bool> containsKey(String key) async {
    final map = await dataSource.getOrNull();
    return map.mapIfNonNull((map) => map.containsKey(key)) ?? false;
  }

  @override
  FutureOr<T> getOrDefault<T>(String key, {required T Function() fallback}) async {
    final map = await dataSource.getOrNull();
    return map.mapIfNonNull((map) => map[key]) ?? fallback();
  }
}
