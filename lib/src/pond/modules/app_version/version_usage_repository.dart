import '../../repository/adapting/default_adapting_repository.dart';
import '../../repository/entity_repository.dart';
import '../environment/environment.dart';
import 'version_usage.dart';
import 'version_usage_entity.dart';

class VersionUsageRepository extends DefaultAdaptingRepository<VersionUsageEntity, VersionUsage> {
  String get dataPath => 'meta';

  @override
  VersionUsageEntity createEntity() {
    return VersionUsageEntity();
  }

  @override
  VersionUsage createValueObject() {
    return VersionUsage();
  }

  @override
  EntityRepository getRepository(Environment environment) {
    switch (environment) {
      case Environment.testing:
        return getLocalRepository();
      default:
        return getFileRepository();
    }
  }
}
