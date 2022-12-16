import 'package:example/pond.dart';
import 'package:flutter/foundation.dart';
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
        return appPondContext;
      },
    );
  }
}

class AppEnvironmentConfig with IsEnvironmentConfigWrapper {
  @override
  EnvironmentConfig get environmentConfig => EnvironmentConfig.static.environmental(
        environmentTypeGetter: () async {
          final overridesDataSource = DataSource.static.asset('assets/config.overrides.yaml').mapYaml();
          final overrides = await overridesDataSource.getOrNull();
          return overrides?['environment'] ?? EnvironmentType.static.production;
        },
        environmentGetter: (type) async {
          final isRelease = kReleaseMode;
          final isWeb = kIsWeb;

          return EnvironmentConfig.static.collapsed([
            EnvironmentConfig.static.yamlAsset('assets/config.overrides.yaml'),
            if (isRelease) EnvironmentConfig.static.yamlAsset('assets/config.release.yaml'),
            if (isWeb) EnvironmentConfig.static.yamlAsset('assets/config.web.yaml'),
            if (type == EnvironmentType.static.testing)
              EnvironmentConfig.static.yamlAsset('assets/config.testing.yaml'),
            if (type == EnvironmentType.static.device) EnvironmentConfig.static.yamlAsset('assets/config.device.yaml'),
            if (type == EnvironmentType.static.qa) EnvironmentConfig.static.yamlAsset('assets/config.uat.yaml'),
            if (type == EnvironmentType.static.production)
              EnvironmentConfig.static.yamlAsset('assets/config.production.yaml'),
            EnvironmentConfig.static.yamlAsset('assets/config.yaml'),
          ]);
        },
      );
}
