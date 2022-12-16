import 'dart:async';

import 'package:environment_core/src/environment_config.dart';
import 'package:environment_core/src/environment_type.dart';

class EnvironmentalEnvironmentConfig with IsEnvironmentConfig {
  final FutureOr<EnvironmentType> Function() environmentTypeGetter;
  final FutureOr<EnvironmentConfig> Function(EnvironmentType environmentType) environmentGetter;

  EnvironmentalEnvironmentConfig({required this.environmentTypeGetter, required this.environmentGetter});

  EnvironmentConfig? config;

  @override
  FutureOr<T> getOrDefault<T>(String key, {required T Function() fallback}) async {
    config ??= await loadConfig();
    return await config!.getOrDefault<T>(key, fallback: fallback);
  }

  Future<EnvironmentConfig> loadConfig() async {
    final environmentType = await environmentTypeGetter();
    final environment = await environmentGetter(environmentType);
    return environment;
  }
}
