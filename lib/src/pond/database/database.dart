import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/query/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/utils/types.dart';

class Database implements QueryExecutor {
  final List<EntityRepository> repositories;

  const Database({required this.repositories});

  EntityRepository<E> getRepository<E extends Entity>() {
    return getRepositoryRuntime(E) as EntityRepository<E>;
  }

  EntityRepository getRepositoryRuntime(Type entityType) {
    return repositories.firstWhereOrNull((repository) => repository.entityType == entityType) ??
        (throw Exception('Cannot find repository for $entityType'));
  }

  @override
  Future<T> executeQuery<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    if (isSubtype<R, Entity>()) {
      final entityRepository = getRepositoryRuntime(R);
      return entityRepository.executeQuery(queryRequest);
    }

    throw Exception('Unable to find repository to handle query request with record of type $R');
  }
}
