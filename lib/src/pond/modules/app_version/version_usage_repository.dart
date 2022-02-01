import 'package:jlogical_utils/jlogical_utils.dart';

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
