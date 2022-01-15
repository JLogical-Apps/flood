import 'package:jlogical_utils/src/pond/context/environment/environment_data_source.dart';

import 'environment.dart';

class DefaultEnvironmentData {
  static EnvironmentDataSource getDataSource(Environment environment) {
    if (environment == Environment.testing) {
      return EnvironmentDataSource.memory;
    } else if (environment == Environment.local) {
      return EnvironmentDataSource.file;
    } else {
      return EnvironmentDataSource.online;
    }
  }
}
