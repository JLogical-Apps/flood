import 'package:drop_core/src/repository/repository.dart';
import 'package:environment_core/environment_core.dart';
import 'package:utils_core/utils_core.dart';

class AdaptingRepository with IsRepositoryWrapper {
  final Repository Function(EnvironmentConfigCoreComponent environment) repositoryGetter;

  AdaptingRepository.custom(this.repositoryGetter);

  AdaptingRepository(String rootPath) : repositoryGetter = _defaultRepositoryGetter(rootPath);

  @override
  late final Repository repository = repositoryGetter(context.locate<EnvironmentConfigCoreComponent>());

  static Repository Function(EnvironmentConfigCoreComponent environment) _defaultRepositoryGetter(String rootPath) {
    return (environment) {
      if (environment.environment == EnvironmentType.static.testing) {
        return Repository.memory();
      } else if (environment.environment == EnvironmentType.static.device) {
        return Repository.file(rootPath).withMemoryCache();
      }

      throw UnimplementedError('Unknown environment for adapting repository [${environment.environment}');
    };
  }
}
