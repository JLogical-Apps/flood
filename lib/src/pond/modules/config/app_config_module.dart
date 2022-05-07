import 'package:jlogical_utils/src/model/model.dart';

import '../../../persistence/export.dart';
import '../../../persistence/export_core.dart';
import 'config_module.dart';

class AppConfigModule extends ConfigModule {
  final String configPath;

  @override
  Model<Map<String, dynamic>> get configModel => Model<Map<String, dynamic>>(
        loader: () async => await _loadConfig(),
      );

  AppConfigModule._({this.configPath: 'assets/config.yaml'});

  static Future<AppConfigModule> create({String configPath: 'assets/config.yaml'}) async {
    final configModule = AppConfigModule._(configPath: configPath);
    await configModule.ensureConfigLoaded();
    return configModule;
  }

  Future<Map<String, dynamic>> _loadConfig() async {
    var config = (await AssetDataSource(assetPath: configPath).mapYaml().getData())!;
    return config;
  }
}
