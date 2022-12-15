import 'package:environment_core/src/environment_config.dart';

class MemoryEnvironmentConfig with IsEnvironmentConfig {
  final Map<String, dynamic> keyValueMap;

  MemoryEnvironmentConfig({required this.keyValueMap});

  @override
  Future<T> getOrDefault<T>(String key, {required T Function() fallback}) {
    return keyValueMap[key] ?? fallback();
  }
}
