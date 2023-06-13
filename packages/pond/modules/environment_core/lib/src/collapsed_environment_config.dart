import 'package:environment_core/src/environment_config.dart';
import 'package:environment_core/src/file_system.dart';

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

  @override
  Future<FileSystem> getFileSystem() {
    throw Exception('No FileSystem');
  }
}
