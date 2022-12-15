import 'package:environment_core/src/environment_config.dart';
import 'package:persistence_core/persistence_core.dart';

class MemoryEnvironmentConfig with IsEnvironmentConfigWrapper {
  final Map<String, dynamic> initialData;

  MemoryEnvironmentConfig({this.initialData = const {}});

  @override
  EnvironmentConfig get environmentConfig =>
      EnvironmentConfig.fromDataSource(DataSource.memory(initialData: initialData));
}
