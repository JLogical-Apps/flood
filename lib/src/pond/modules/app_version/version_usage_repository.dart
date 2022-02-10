import '../../repository/adapting/default_adapting_repository.dart';
import '../../repository/entity_repository.dart';
import '../../repository/file/simple_file_repository.dart';
import '../../repository/local/simple_local_repository.dart';
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
        return SimpleLocalRepository<VersionUsageEntity, VersionUsage>(
          onCreateEntity: createEntity,
          onCreateValueObject: createValueObject,
        );
      default:
        return SimpleFileRepository<VersionUsageEntity, VersionUsage>(
          dataPath: dataPath,
          onCreateEntity: createEntity,
          onCreateValueObject: createValueObject,
        );
    }
  }
}
