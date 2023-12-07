import 'package:environment_core/environment_core.dart';
import 'package:pond/pond.dart';

extension EnvironmentAppPondContextExtensions on AppPondContext {
  EnvironmentConfigCoreComponent get environmentCoreComponent => find<EnvironmentConfigCoreComponent>();

  EnvironmentConfig get environmentConfig => environmentCoreComponent.environmentConfig;

  BuildType get buildType => environmentCoreComponent.buildType;

  Platform get platform => environmentCoreComponent.platform;

  EnvironmentType get environment => environmentCoreComponent.environment;

  T environmental<T>(T Function(EnvironmentType type) getter) {
    return getter(environment);
  }
}
