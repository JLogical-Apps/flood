import 'package:environment/src/environment_config_extension.dart';
import 'package:environment/src/flutter_environment_static_extension.dart';
import 'package:environment_core/environment_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistence/persistence.dart';

class FlutterAssetEnvironmentConfig with IsEnvironmentConfigWrapper {
  final EnvironmentType? releaseBuildType;

  FlutterAssetEnvironmentConfig({this.releaseBuildType});

  @override
  EnvironmentConfig get environmentConfig {
    final baseConfig = EnvironmentConfig.static
        .yamlAsset('assets/config.overrides.yaml')
        .withRecognizedEnvironmentTypes(EnvironmentType.static.defaultTypes)
        .forFlutter()
        .withReleaseBuildEnvironmentType(releaseBuildType);

    return baseConfig.environmental((type) async {
      final isRelease = await baseConfig.getBuildType() == BuildType.release;
      final isWeb = await baseConfig.getPlatform() == Platform.web;

      return EnvironmentConfig.static.collapsed([
        EnvironmentConfig.static.yamlAsset('assets/config.overrides.yaml'),
        if (!isWeb) EnvironmentConfig.static.environmentVariables(),
        if (isRelease) EnvironmentConfig.static.yamlAsset('assets/config.release.yaml'),
        if (isWeb) EnvironmentConfig.static.yamlAsset('assets/config.web.yaml'),
        EnvironmentConfig.static.yamlAsset('assets/config.${type.name}.yaml'),
        EnvironmentConfig.static.yamlAsset('assets/config.yaml'),
      ]);
    }).withFileSystemGetter(() async {
      final platform = await baseConfig.getPlatform();
      if (platform == Platform.web) {
        return FileSystem(
          storageDirectory: CrossDirectory.static.web('storage'),
          tempDirectory: CrossDirectory.static.web('temp'),
        );
      } else {
        return FileSystem.io(
          storageDirectory: await getApplicationSupportDirectory(),
          tempDirectory: await getTemporaryDirectory(),
        );
      }
    });
  }
}
