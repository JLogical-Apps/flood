import 'package:flutter/foundation.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class ConfigModule extends AppModule {
  final String configPath;
  final String? releaseConfigPath;

  Map<String, dynamic> get config => _configModel.value.get();

  late final _configModel = Model<Map<String, dynamic>>(
    loader: () async => await _loadConfig(),
  );

  ConfigModule({
    this.configPath: 'assets/config.yaml',
    this.releaseConfigPath: 'assets/config_release.yaml',
  });

  Future<void> onLoad(AppContext appContext) async {
    await _configModel.ensureLoaded();
  }

  Future<Map<String, dynamic>> ensureConfigLoaded() async {
    return _configModel.ensureLoadedAndGet();
  }

  Future<Environment> getEnvironmentFromConfig() async {
    final config = await ensureConfigLoaded();
    final envName = config['env'] ??
        config['environment'] ??
        (throw Exception('Could not find environment in config file at `$configPath`!'));
    final environment = Environment.values.firstWhere((env) => env.name == envName);
    return environment;
  }

  Future<Map<String, dynamic>> _loadConfig() async {
    var config = (await AssetDataSource(assetPath: configPath).mapYaml().getData())!;

    // Use the release config path to override any values in the base config if this is in release mode.
    if (kReleaseMode && releaseConfigPath != null) {
      final releaseConfigOverrides = (await AssetDataSource(assetPath: releaseConfigPath!).mapYaml().getData())!;
      releaseConfigOverrides.forEach((key, value) => config[key] = value);
    }

    return config;
  }
}
