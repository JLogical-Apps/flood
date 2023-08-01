import 'package:drop_core/src/repository/repository.dart';
import 'package:environment_core/environment_core.dart';

class AdaptingRepository with IsRepositoryWrapper {
  final String rootPath;

  AdaptingRepository({required this.rootPath});

  @override
  late final Repository repository = () {
    if (context.environment == EnvironmentType.static.testing) {
      return Repository.memory();
    } else if (context.environment == EnvironmentType.static.device) {
      return Repository.file(rootPath).withMemoryCache();
    } else {
      return Repository.cloud(rootPath).withMemoryCache();
    }
  }();
}
