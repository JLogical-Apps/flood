import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/pond/query/query_executor.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';
import 'package:jlogical_utils/src/utils/stream_extensions.dart';
import 'package:rxdart/rxdart.dart';

abstract class Database implements QueryExecutor {
  EntityRepository? getRepositoryRuntimeOrNull(Type entityType);
}

extension DefaultDatabase on Database {
  EntityRepository getRepositoryRuntime(Type entityType) {
    return getRepositoryRuntimeOrNull(entityType) ?? (throw Exception('Cannot find repository for $entityType'));
  }

  EntityRepository getRepository<E extends Entity>() {
    return getRepositoryRuntime(E);
  }

  Future<void> save(Entity entity, {Transaction? transaction}) {
    return getRepositoryRuntime(entity.runtimeType).save(entity, transaction: transaction);
  }

  Future<E?> getOrNull<E extends Entity>(String id, {Transaction? transaction}) async {
    return (await getRepository<E>().getOrNull(id, transaction: transaction)) as E?;
  }

  ValueStream<FutureValue<E>>? getXOrNull<E extends Entity>(String id) {
    return getRepository<E>().getXOrNull(id)?.mapWithValue((value) => value.mapIfPresent((value) => value as E));
  }

  Future<E> get<E extends Entity>(String id, {Transaction? transaction}) async {
    return (await getRepository<E>().get(id, transaction: transaction)) as E;
  }

  ValueStream<FutureValue<E>> getX<E extends Entity>(String id) {
    return getRepository<E>().getX(id).mapWithValue((value) => value.mapIfPresent((value) => value as E));
  }

  Future<void> delete(Entity entity, {Transaction? transaction}) {
    final id = entity.id ?? (throw Exception('Cannot delete an entity that has not been saved!'));
    return getRepositoryRuntime(entity.runtimeType).delete(id, transaction: transaction);
  }

  Future<void> create(Entity entity, {Transaction? transaction}) {
    return getRepositoryRuntime(entity.runtimeType).create(entity, transaction: transaction);
  }
}
