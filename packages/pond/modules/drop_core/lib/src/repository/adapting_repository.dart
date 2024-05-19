import 'package:drop_core/src/repository/repository.dart';
import 'package:environment_core/environment_core.dart';

class AdaptingRepository with IsRepositoryWrapper {
  final String rootPath;
  final Repository childRepository;
  final Repository Function(EnvironmentConfigCoreComponent config)? repositoryGetter;

  AdaptingRepository({required this.rootPath, required this.childRepository, this.repositoryGetter});

  @override
  late final Repository repository = () {
    if (repositoryGetter != null) {
      return repositoryGetter!(context.environmentCoreComponent);
    }

    if (context.environment == EnvironmentType.static.testing) {
      return childRepository.memory();
    } else if (context.environment == EnvironmentType.static.device) {
      return childRepository.file(rootPath).withMemoryCache();
    } else {
      return childRepository.cloud(rootPath).withMemoryCache();
    }
  }();
}
