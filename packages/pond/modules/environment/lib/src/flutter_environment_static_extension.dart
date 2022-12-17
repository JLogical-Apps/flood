import 'package:environment/src/flutter_asset_environment_config.dart';
import 'package:environment_core/environment_core.dart';
import 'package:persistence/persistence.dart';

extension FlutterEnvironmentConfigStaticExtension on EnvironmentConfigStatic {
  DataSourceEnvironmentConfig yamlAsset(String assetPath) =>
      fromDataSource(DataSource.static.asset(assetPath).mapYaml());

  FlutterAssetEnvironmentConfig flutterAssets() => FlutterAssetEnvironmentConfig();
}
