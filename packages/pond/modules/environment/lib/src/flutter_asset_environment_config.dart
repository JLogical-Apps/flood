import 'package:environment/src/environment_config_extension.dart';
import 'package:environment/src/flutter_environment_static_extension.dart';
import 'package:environment_core/environment_core.dart';
import 'package:path_provider/path_provider.dart';

class FlutterAssetEnvironmentConfig with IsEnvironmentConfigWrapper {
  @override
  EnvironmentConfig get environmentConfig {
    final baseConfig = EnvironmentConfig.static
        .yamlAsset('assets/config.overrides.yaml')
        .withRecognizedEnvironmentTypes(EnvironmentType.static.defaultTypes)
        .forFlutter();

    return baseConfig.environmental((type) async {
      final isRelease = await baseConfig.getBuildType() == BuildType.release;
      final isWeb = await baseConfig.getPlatform() == Platform.web;

      return EnvironmentConfig.static.collapsed([
        EnvironmentConfig.static.yamlAsset('assets/config.overrides.yaml'),
        if (isRelease) EnvironmentConfig.static.yamlAsset('assets/config.release.yaml'),
        if (isWeb) EnvironmentConfig.static.yamlAsset('assets/config.web.yaml'),
        if (type == EnvironmentType.static.testing) EnvironmentConfig.static.yamlAsset('assets/config.testing.yaml'),
        if (type == EnvironmentType.static.device) EnvironmentConfig.static.yamlAsset('assets/config.device.yaml'),
        if (type == EnvironmentType.static.qa) EnvironmentConfig.static.yamlAsset('assets/config.uat.yaml'),
        if (type == EnvironmentType.static.staging) EnvironmentConfig.static.yamlAsset('assets/config.staging.yaml'),
        if (type == EnvironmentType.static.production)
          EnvironmentConfig.static.yamlAsset('assets/config.production.yaml'),
        EnvironmentConfig.static.yamlAsset('assets/config.yaml'),
      ]);
    }).withFileSystemGetter(() async {
      return FileSystem(
        storageDirectory: await getApplicationSupportDirectory(),
        tempDirectory: await getTemporaryDirectory(),
      );
    });
  }
}
