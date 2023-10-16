import 'package:environment_core/environment_core.dart';
import 'package:pond/pond.dart';

extension EnvironmentAppPondContextExtensions on AppPondContext {
  EnvironmentConfig get environmentConfig => find<EnvironmentConfigCoreComponent>().environmentConfig;

  BuildType get buildType => find<EnvironmentConfigCoreComponent>().buildType;

  Platform get platform => find<EnvironmentConfigCoreComponent>().platform;

  EnvironmentType get environment => find<EnvironmentConfigCoreComponent>().environment;

  T environmental<T>(T Function(EnvironmentType type) getter) {
    return getter(environment);
  }
}
