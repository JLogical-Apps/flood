import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor_x.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/utils/stream_extensions.dart';
import 'package:rxdart/rxdart.dart';

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

  Future<E?> getOrNull<E extends Entity>(String id) async {
    return (await getRepository<E>().getOrNull(id)) as E?;
  }

  ValueStream<FutureValue<E>> getXOrNull<E extends Entity>(String id) {
    return getRepository<E>().getXOrNull(id).mapWithValue((value) => value.mapIfPresent((value) => value as E));
  }

  Future<E> get<E extends Entity>(String id) async {
    return (await getRepository<E>().get(id)) as E;
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
