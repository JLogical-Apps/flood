import 'package:environment_core/src/build_type.dart';
import 'package:environment_core/src/environment_config.dart';
import 'package:environment_core/src/environment_config_module.dart';
import 'package:environment_core/src/environment_type.dart';
import 'package:environment_core/src/platform.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

extension EnvironmentCoreContextExtensions on CorePondContext {
  EnvironmentConfig get environmentConfig => locate<EnvironmentConfigModule>().environmentConfig;

  BuildType get buildType => locate<EnvironmentConfigModule>().buildType;

  Platform get platform => locate<EnvironmentConfigModule>().platform;

  EnvironmentType get environment => locate<EnvironmentConfigModule>().environment;
}

extension EnvironmentAutomateContextExtensions on AutomatePondContext {
  EnvironmentConfig get environmentConfig => find<EnvironmentConfigModule>().environmentConfig;

  BuildType get buildType => find<EnvironmentConfigModule>().buildType;

  Platform get platform => find<EnvironmentConfigModule>().platform;

  EnvironmentType get environment => find<EnvironmentConfigModule>().environment;
}
