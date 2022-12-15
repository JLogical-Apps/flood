import 'dart:io';

import 'package:environment_core/src/environment_config.dart';
import 'package:persistence_core/persistence_core.dart';

class FileEnvironmentConfig with IsEnvironmentConfigWrapper {
  final File file;

  FileEnvironmentConfig({required this.file});

  @override
  EnvironmentConfig get environmentConfig => EnvironmentConfig.fromDataSource(DataSource.file(file).mapYaml());
}
