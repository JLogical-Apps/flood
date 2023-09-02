import 'package:environment_core/src/environment_config.dart';
import 'package:environment_core/src/environment_type.dart';

class EnvironmentTypeEnvironmentConfig with IsEnvironmentConfigWrapper {
  final EnvironmentType environmentType;

  @override
  final EnvironmentConfig environmentConfig;

  EnvironmentTypeEnvironmentConfig({required this.environmentType, required this.environmentConfig});

  @override
  Future<EnvironmentType> getEnvironmentType() async {
    return environmentType;
  }
}
