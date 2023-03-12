import 'package:drop_core/src/repository/repository.dart';
import 'package:environment_core/environment_core.dart';
import 'package:utils_core/utils_core.dart';

class AdaptingRepository with IsRepositoryWrapper {
  final Repository Function(EnvironmentConfigCoreComponent environment) repositoryGetter;

  AdaptingRepository(this.repositoryGetter);

  @override
  Repository get repository => repositoryGetter(context.locate<EnvironmentConfigCoreComponent>());
}
