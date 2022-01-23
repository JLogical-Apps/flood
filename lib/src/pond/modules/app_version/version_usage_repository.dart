import 'dart:io';

import 'package:jlogical_utils/jlogical_utils.dart';

import 'version_usage.dart';
import 'version_usage_entity.dart';

class VersionUsageRepository extends DefaultAdaptingRepository<VersionUsageEntity, VersionUsage> {
  @override
  final Directory baseDirectory;

  String get collectionPath => throw UnimplementedError('Version Usage cannot be saved online!');

  VersionUsageRepository({required this.baseDirectory});

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
          baseDirectory: baseDirectory,
          onCreateEntity: createEntity,
          onCreateValueObject: createValueObject,
        );
    }
  }
}
