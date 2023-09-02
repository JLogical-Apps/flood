import 'package:environment/src/flutter_environment_config_setup.dart';
import 'package:environment_core/environment_core.dart';

extension FlutterEnvironmentConfigExtensions on EnvironmentConfig {
  FlutterEnvironmentConfigSetup forFlutter() {
    return FlutterEnvironmentConfigSetup(environmentConfig: this);
  }
}
