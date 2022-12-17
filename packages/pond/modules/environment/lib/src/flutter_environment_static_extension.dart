import 'package:environment_core/environment_core.dart';
import 'package:persistence/persistence.dart';

extension FlutterEnvironmentConfigStaticExtension on EnvironmentConfigStatic {
  DataSourceEnvironmentConfig yamlAsset(String assetPath) =>
      fromDataSource(DataSource.static.asset(assetPath).mapYaml());
}
