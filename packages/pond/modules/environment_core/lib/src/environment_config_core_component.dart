import 'package:environment_core/src/build_type.dart';
import 'package:environment_core/src/environment_config.dart';
import 'package:environment_core/src/environment_type.dart';
import 'package:environment_core/src/file_system.dart';
import 'package:environment_core/src/platform.dart';
import 'package:pond_core/pond_core.dart';

class EnvironmentConfigCoreComponent with IsCorePondComponent, IsCorePondComponentBehavior, IsEnvironmentConfigWrapper {
  @override
  final EnvironmentConfig environmentConfig;

  late EnvironmentType environment;
  late BuildType buildType;
  late Platform platform;
  late FileSystem fileSystem;

  EnvironmentConfigCoreComponent({required this.environmentConfig});

  @override
  Future onRegister(CorePondContext context, CorePondComponent component) async {
    environment = await getEnvironmentType();
    buildType = await getBuildType();
    platform = await getPlatform();
    fileSystem = await getFileSystem();
  }

  @override
  List<CorePondComponentBehavior> get behaviors => [this];
}
