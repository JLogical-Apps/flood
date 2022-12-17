import 'package:environment_core/environment_core.dart';

class EnvironmentTypeEnvironmentConfig with IsEnvironmentConfig {
  final EnvironmentType environmentType;

  EnvironmentTypeEnvironmentConfig({required this.environmentType});

  @override
  Future<EnvironmentType> getEnvironmentType() async {
    return environmentType;
  }

  @override
  Future<T> getOrDefault<T>(String key, {required T Function() fallback}) {
    throw UnimplementedError();
  }
}
