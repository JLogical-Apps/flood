import 'package:environment_core/src/environment_config.dart';
import 'package:environment_core/src/environment_type.dart';
import 'package:pond_core/pond_core.dart';

class EnvironmentConfigModule with IsCorePondComponent, IsCorePondComponentBehavior {
  late EnvironmentType environmentType;

  final EnvironmentConfig config;

  EnvironmentConfigModule({required this.config});

  Future<T> getOrDefault<T>(String key, {required T Function() fallback}) async {
    return await config.getOrDefault<T>(key, fallback: fallback);
  }

  @override
  Future onRegister(CorePondContext context, CorePondComponent component) async {
    environmentType = await config.getOrDefault(
      'environment',
      fallback: () => EnvironmentType.static.testing,
    );
  }

  @override
  List<CorePondComponentBehavior> get behaviors => [this];
}
