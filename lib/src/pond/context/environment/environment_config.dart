import 'package:jlogical_utils/src/persistence/data_source/asset_data_source.dart';
import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';

import 'environment.dart';

class EnvironmentConfig {
  static Future<Environment> readFromAssetConfig([String assetPath = 'assets/config.yaml']) async {
    final dataSource = AssetDataSource(assetPath: assetPath).mapYaml();
    final config = (await dataSource.getData()) ?? (throw Exception('Cannot get the config from $assetPath!'));
    final environmentName =
        config['env'] ?? (throw Exception('Cannot get environment from the config at $assetPath'));
    final environment = Environment.values.firstWhere((env) => env.name == environmentName);
    return environment;
  }
}
