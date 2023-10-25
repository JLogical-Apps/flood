import 'dart:async';
import 'dart:io';

import 'package:environment_core/src/environment_config.dart';
import 'package:environment_core/src/file_system.dart';
import 'package:utils_core/utils_core.dart';

class EnvironmentVariablesEnvironmentConfig with IsEnvironmentConfig {
  late Map<String, String> environmentVariables = Platform.environment;

  @override
  Future<bool> containsKey(String key) async {
    return environmentVariables.containsKey(key);
  }

  @override
  Future<T> getOrDefault<T>(String key, {required T Function() fallback}) async {
    return coerce<T>(environmentVariables[key]) ?? fallback();
  }

  @override
  Future<FileSystem> getFileSystem() {
    throw Exception('No FileSystem');
  }
}
