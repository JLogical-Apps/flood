import 'package:environment_core/src/build_type.dart';
import 'package:environment_core/src/environment_config.dart';
import 'package:environment_core/src/environment_config_core_component.dart';
import 'package:environment_core/src/environment_type.dart';
import 'package:environment_core/src/file_system.dart';
import 'package:environment_core/src/platform.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

extension EnvironmentCoreContextExtensions on CorePondContext {
  EnvironmentConfig get environmentConfig => locate<EnvironmentConfigCoreComponent>().environmentConfig;

  BuildType get buildType => locate<EnvironmentConfigCoreComponent>().buildType;

  Platform get platform => locate<EnvironmentConfigCoreComponent>().platform;

  EnvironmentType get environment => locate<EnvironmentConfigCoreComponent>().environment;

  FileSystem get fileSystem => locate<EnvironmentConfigCoreComponent>().fileSystem;
}
