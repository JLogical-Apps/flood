import 'package:environment_core/src/environment_config.dart';
import 'package:pond_core/pond_core.dart';

class EnvironmentConfigModule extends CorePondComponent {
  final EnvironmentConfig config;

  EnvironmentConfigModule({required this.config});

  Future<T> getOrDefault<T>(String key, {required T Function() fallback}) async {
    return await config.getOrDefault<T>(key, fallback: fallback);
  }
}
