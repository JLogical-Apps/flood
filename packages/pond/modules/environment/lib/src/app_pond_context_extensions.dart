import 'package:environment_core/environment_core.dart';
import 'package:pond/pond.dart';

extension EnvironmentAppPondContextExtensions on AppPondContext {
  EnvironmentConfig get environmentConfig => find<EnvironmentConfigModule>().environmentConfig;

  BuildType get buildType => find<EnvironmentConfigModule>().buildType;

  Platform get platform => find<EnvironmentConfigModule>().platform;

  EnvironmentType get environment => find<EnvironmentConfigModule>().environment;
}
