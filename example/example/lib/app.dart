import 'package:example/pond.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

Future<void> main(List<String> args) async {
  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PondApp(
      appPondContextGetter: () async {
        final corePondContext = await getCorePondContext(environmentConfig: AppEnvironmentConfig());
        final appPondContext = AppPondContext(corePondContext: corePondContext);
        await appPondContext.register(EnvironmentBannerAppComponent());
        return appPondContext;
      },
    );
  }
}

class AppEnvironmentConfig with IsEnvironmentConfigWrapper {
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
        if (type == EnvironmentType.static.production)
          EnvironmentConfig.static.yamlAsset('assets/config.production.yaml'),
        EnvironmentConfig.static.yamlAsset('assets/config.yaml'),
      ]);
    });
  }
}
