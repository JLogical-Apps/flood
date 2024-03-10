import 'package:environment_core/src/build_type.dart';
import 'package:environment_core/src/environment_config.dart';
import 'package:environment_core/src/environment_type.dart';

class ReleaseBuildTypeEnvironmentConfig with IsEnvironmentConfigWrapper {
  final EnvironmentType releaseBuildEnvironmentType;

  @override
  final EnvironmentConfig environmentConfig;

  ReleaseBuildTypeEnvironmentConfig({required this.releaseBuildEnvironmentType, required this.environmentConfig});

  @override
  Future<EnvironmentType> getEnvironmentType() async {
    final buildType = await environmentConfig.getBuildType();
    if (buildType == BuildType.release) {
      return releaseBuildEnvironmentType;
    }

    return await environmentConfig.getEnvironmentType();
  }
}
