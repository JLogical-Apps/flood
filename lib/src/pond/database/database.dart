import 'package:jlogical_utils/src/pond/query/executor/query_executor_x.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';

abstract class Database implements QueryExecutorX {
  EntityRepository? getRepositoryRuntimeOrNull(Type entityType);
}

extension DefaultDatabase on Database {
  EntityRepository getRepositoryRuntime(Type entityType) {
    return getRepositoryRuntimeOrNull(entityType) ?? (throw Exception('Cannot find repository for $entityType'));
  }

  EntityRepository getRepository<E extends Entity>() {
    return getRepositoryRuntime(E);
  }

  Future<void> save(Entity entity) {
    return getRepositoryRuntime(entity.runtimeType).save(entity);
  }

  Future<void> delete(Entity entity) {
    if (entity.isNew) {
      throw Exception('Cannot delete an entity that has not been saved!');
    }
    return getRepositoryRuntime(entity.runtimeType).delete(entity);
  }

  Future<void> create(Entity entity) {
    return getRepositoryRuntime(entity.runtimeType).create(entity);
  }

  Future<void> createOrSave(Entity entity) {
    return getRepositoryRuntime(entity.runtimeType).createOrSave(entity);
  }
}
