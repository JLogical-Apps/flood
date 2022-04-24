import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/patterns/command/command.dart';
import 'package:jlogical_utils/src/pond/modules/debug/debuggable_module.dart';

import '../../../patterns/command/simple_command.dart';

class ConfigModule extends AppModule implements DebuggableModule {
  final String configPath;

  Map<String, dynamic> get config => _configModel.value.get();

  late final _configModel = Model<Map<String, dynamic>>(
    loader: () async => await _loadConfig(),
  );

  ConfigModule({this.configPath: 'assets/config.yaml'});

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
          runner: (args) {
            return config;
          },
        ),
      ];
}
