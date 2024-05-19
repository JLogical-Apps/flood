import 'package:drop_core/src/repository/repository.dart';
import 'package:environment_core/environment_core.dart';

class EnvironmentalRepository with IsRepositoryWrapper {
  final Repository childRepository;
  final Repository Function(Repository repository, EnvironmentConfigCoreComponent config) repositoryGetter;

  EnvironmentalRepository({required this.childRepository, required this.repositoryGetter});

  @override
  late final Repository repository = repositoryGetter(childRepository, context.environmentCoreComponent);
}
