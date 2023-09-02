import 'dart:async';

import 'package:environment_core/src/environment_config.dart';
import 'package:environment_core/src/environment_type.dart';

class EnvironmentalEnvironmentConfig with IsEnvironmentConfigWrapper {
  @override
  final EnvironmentConfig environmentConfig;

  final FutureOr<EnvironmentConfig> Function(EnvironmentType environmentType) environmentGetter;

  EnvironmentalEnvironmentConfig({required this.environmentConfig, required this.environmentGetter});

  EnvironmentConfig? config;

  @override
  Future<T> getOrDefault<T>(String key, {required T Function() fallback}) async {
    config ??= await environmentGetter(await getEnvironmentType());
    return await config!.getOrDefault<T>(key, fallback: fallback);
  }
}
