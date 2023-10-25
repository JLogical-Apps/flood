import 'dart:io';

import 'package:environment_core/environment_core.dart';
import 'package:utils_core/utils_core.dart';

class FileAssetEnvironmentConfig with IsEnvironmentConfigWrapper {
  final Directory projectDirectory;

  FileAssetEnvironmentConfig({Directory? projectDirectory}) : projectDirectory = projectDirectory ?? Directory.current;

  @override
  EnvironmentConfig get environmentConfig {
    final baseConfig = EnvironmentConfig.static
        .yamlFile(projectDirectory - 'assets/config.overrides.yaml')
        .withRecognizedEnvironmentTypes(EnvironmentType.static.defaultTypes)
        .withFileSystemGetter(() => FileSystem.io(
              storageDirectory: projectDirectory / 'tool' / 'output',
              tempDirectory: projectDirectory / 'tool' / 'tmp',
            ));

    return baseConfig.environmental((type) async {
      final isRelease = await baseConfig.getBuildType() == BuildType.release;
      final isWeb = await baseConfig.getPlatform() == Platform.web;

      return EnvironmentConfig.static.collapsed([
        EnvironmentConfig.static.yamlFile(projectDirectory - 'assets/config.overrides.yaml'),
        EnvironmentConfig.static.environmentVariables(),
        if (isRelease) EnvironmentConfig.static.yamlFile(projectDirectory - 'assets/config.release.yaml'),
        if (isWeb) EnvironmentConfig.static.yamlFile(projectDirectory - 'assets/config.web.yaml'),
        if (type == EnvironmentType.static.testing)
          EnvironmentConfig.static.yamlFile(projectDirectory - 'assets/config.testing.yaml'),
        if (type == EnvironmentType.static.device)
          EnvironmentConfig.static.yamlFile(projectDirectory - 'assets/config.device.yaml'),
        if (type == EnvironmentType.static.qa)
          EnvironmentConfig.static.yamlFile(projectDirectory - 'assets/config.uat.yaml'),
        if (type == EnvironmentType.static.production)
          EnvironmentConfig.static.yamlFile(projectDirectory - 'assets/config.production.yaml'),
        EnvironmentConfig.static.yamlFile(projectDirectory - 'assets/config.yaml'),
      ]);
    });
  }
}
