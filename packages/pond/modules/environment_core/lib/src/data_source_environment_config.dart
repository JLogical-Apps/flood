import 'dart:async';

import 'package:environment_core/src/environment_config.dart';
import 'package:environment_core/src/file_system.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:utils_core/utils_core.dart';

class DataSourceEnvironmentConfig with IsEnvironmentConfig {
  final DataSource<Map<String, dynamic>> dataSource;

  DataSourceEnvironmentConfig({required this.dataSource});

  @override
  Future<bool> containsKey(String key) async {
    final map = await dataSource.getOrNull();
    return map.mapIfNonNull((map) => map.containsKey(key)) ?? false;
  }

  @override
  Future<T> getOrDefault<T>(String key, {required T Function() fallback}) async {
    final map = await dataSource.getOrNull();
    return map.mapIfNonNull((map) => map[key]) ?? fallback();
  }

  @override
  Future<FileSystem> getFileSystem() {
    throw Exception('No FileSystem');
  }
}
