import 'dart:io';

import 'package:environment_core/environment_core.dart';
import 'package:utils_core/utils_core.dart';

class FileAssetEnvironmentConfig with IsEnvironmentConfigWrapper {
  @override
  EnvironmentConfig get environmentConfig {
    final baseConfig = EnvironmentConfig.static
        .yamlFile(Directory.current - 'assets/config.overrides.yaml')
        .withRecognizedEnvironmentTypes(EnvironmentType.static.defaultTypes)
        .withFileSystemGetter(() => FileSystem(
              storageDirectory: Directory.current / 'tool' / 'output',
              tempDirectory: Directory.current / 'tool' / 'tmp',
            ));

    return baseConfig.environmental((type) async {
      final isRelease = await baseConfig.getBuildType() == BuildType.release;
      final isWeb = await baseConfig.getPlatform() == Platform.web;

      return EnvironmentConfig.static.collapsed([
        EnvironmentConfig.static.yamlFile(Directory.current - 'assets/config.overrides.yaml'),
        if (isRelease) EnvironmentConfig.static.yamlFile(Directory.current - 'assets/config.release.yaml'),
        if (isWeb) EnvironmentConfig.static.yamlFile(Directory.current - 'assets/config.web.yaml'),
        if (type == EnvironmentType.static.testing)
          EnvironmentConfig.static.yamlFile(Directory.current - 'assets/config.testing.yaml'),
        if (type == EnvironmentType.static.device)
          EnvironmentConfig.static.yamlFile(Directory.current - 'assets/config.device.yaml'),
        if (type == EnvironmentType.static.qa)
          EnvironmentConfig.static.yamlFile(Directory.current - 'assets/config.uat.yaml'),
        if (type == EnvironmentType.static.production)
          EnvironmentConfig.static.yamlFile(Directory.current - 'assets/config.production.yaml'),
        EnvironmentConfig.static.yamlFile(Directory.current - 'assets/config.yaml'),
      ]);
    });
  }
}
