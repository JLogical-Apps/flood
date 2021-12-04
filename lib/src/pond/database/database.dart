import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/pond/query/query_executor.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';
import 'package:rxdart/rxdart.dart';

abstract class Database implements QueryExecutor {
  EntityRepository? getRepositoryRuntimeOrNull(Type entityType);
}

extension DefaultDatabase on Database {
  EntityRepository getRepositoryRuntime(Type entityType) {
    return getRepositoryRuntimeOrNull(entityType) ?? (throw Exception('Cannot find repository for $entityType'));
  }

  EntityRepository<E> getRepository<E extends Entity>() {
    return getRepositoryRuntime(E) as EntityRepository<E>;
  }

  Future<void> save<E extends Entity>(E entity, {Transaction? transaction}) {
    return getRepository<E>().save(entity, transaction: transaction);
  }

  Future<E?> getOrNull<E extends Entity>(String id, {Transaction? transaction}) {
    return getRepository<E>().getOrNull(id, transaction: transaction);
  }

  ValueStream<FutureValue<E>>? getXOrNull<E extends Entity>(String id) {
    return getRepository<E>().getXOrNull(id);
  }

  Future<E> get<E extends Entity>(String id, {Transaction? transaction}) async {
    return getRepository<E>().get(id, transaction: transaction);
  }

  ValueStream<FutureValue<E>> getX<E extends Entity>(String id) {
    return getRepository<E>().getX(id);
  }

  Future<void> delete<E extends Entity>(String id, {Transaction? transaction}) {
    return getRepository<E>().delete(id, transaction: transaction);
  }

  Future<void> create<E extends Entity>(E entity, {Transaction? transaction}) {
    return getRepository<E>().create(entity, transaction: transaction);
  }
}
