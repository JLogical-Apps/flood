import 'package:example_core/components/testing_utility_component.dart';
import 'package:flood_core/flood_core.dart';

extension RepositoryExtensions on Repository {
  Repository syncingOrAdapting(String rootPath) {
    return environmental((repository, config) {
      if (config.context.testingComponent.useSyncing) {
        return repository.syncing(rootPath);
      } else {
        return repository.adapting(rootPath);
      }
    });
  }
}
