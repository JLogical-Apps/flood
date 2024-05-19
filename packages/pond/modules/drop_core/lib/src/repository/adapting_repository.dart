import 'package:drop_core/src/repository/repository.dart';
import 'package:environment_core/environment_core.dart';

class AdaptingRepository with IsRepositoryWrapper {
  final String rootPath;
  final Repository childRepository;

  AdaptingRepository({required this.rootPath, required this.childRepository});

  @override
  late final Repository repository = () {
    if (context.environment == EnvironmentType.static.testing) {
      return childRepository.memory();
    } else if (context.environment == EnvironmentType.static.device) {
      return childRepository.file(rootPath).withMemoryCache();
    } else {
      return childRepository.cloud(rootPath).withMemoryCache();
    }
  }();
}
