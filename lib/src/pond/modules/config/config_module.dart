import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/persistence/export_core.dart';
import 'package:jlogical_utils/src/pond/modules/debug/debuggable_module.dart';

import '../../../model/export_core.dart';
import '../../../persistence/data_source/asset_data_source.dart';
import '../../context/app_context.dart';
import '../../context/module/app_module.dart';
import '../environment/environment.dart';

class ConfigModule extends AppModule implements DebuggableModule {
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

  @override
  List<Command> get debugCommands => [
        SimpleCommand(
          name: 'get_config',
          displayName: 'Config',
          description: 'Gets the current config values.',
          runner: (args) {
            return config;
          },
        ),
      ];
}
