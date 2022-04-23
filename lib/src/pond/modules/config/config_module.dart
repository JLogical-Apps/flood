import 'package:jlogical_utils/jlogical_utils.dart';

class ConfigModule extends AppModule {
  final String configPath;

  Map<String, dynamic> get config => _configModel.value.get();

  late final _configModel = Model<Map<String, dynamic>>(
    loader: () async => await _loadConfig(),
  );

  ConfigModule._({this.configPath: 'assets/config.yaml'});

  static Future<ConfigModule> create({String configPath: 'assets/config.yaml'}) async {
    final configModule = ConfigModule._(configPath: configPath);
    await configModule.ensureConfigLoaded();
    return configModule;
  }

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
    return config;
  }
}
