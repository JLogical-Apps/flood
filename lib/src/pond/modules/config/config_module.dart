import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/pond/modules/debug/debuggable_module.dart';

import '../../../model/export_core.dart';
import '../../context/app_context.dart';
import '../../context/module/app_module.dart';
import '../environment/environment.dart';

abstract class ConfigModule extends AppModule implements DebuggableModule {
  Model<Map<String, dynamic>> get configModel;

  late final _configModel = configModel;

  Map<String, dynamic> get config => _configModel.value.get();

  Future<void> onLoad(AppContext appContext) async {
    await _configModel.ensureLoaded();
  }

  Future<Map<String, dynamic>> ensureConfigLoaded() async {
    return _configModel.ensureLoadedAndGet();
  }

  Future<Environment> getEnvironmentFromConfig() async {
    final config = await ensureConfigLoaded();
    final envName =
        config['env'] ?? config['environment'] ?? (throw Exception('Could not find environment in config file!'));
    final environment = Environment.values.firstWhere((env) => env.name == envName);
    return environment;
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
