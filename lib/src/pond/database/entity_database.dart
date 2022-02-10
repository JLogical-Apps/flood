import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor_x.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';
import 'package:jlogical_utils/src/utils/utils.dart';
import 'package:lumberdash/lumberdash.dart';
import 'package:rxdart/rxdart.dart';

import 'query/with_query_cache_manager.dart';

class EntityDatabase with WithQueryCacheManager implements Database {
  final List<EntityRepository> _repositories;

  EntityDatabase({List<EntityRepository>? repositories}) : _repositories = repositories ?? [];

  @override
  EntityRepository getRepositoryRuntimeOrNull(Type entityType) {
    return _repositories.firstWhereOrNull((repository) =>
            repository.handledEntityTypes.any((handledType) => AppContext.global.isSubtype(entityType, handledType))) ??
        (throw Exception('Could not find repository for entity $entityType'));
  }

  void registerRepository(EntityRepository repository) {
    _repositories.add(repository);
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    if (isSubtype<R, Entity>()) {
      final entityRepository = getRepositoryRuntime(R);
      if (queryRequest.isWithoutCache()) {
        throw Exception('Cannot run `useQueryX()` with a `withoutCache()` query!');
      }

      final modifiedQueryRequest = modifiedWithoutCacheIfNeeded(queryRequest);
      if (modifiedQueryRequest.isWithoutCache()) {
        logMessage('Calling without-cache due to useQueryX [$queryRequest]');
        entityRepository.executeQuery(modifiedQueryRequest); // Run the cacheless query in order to fetch latest data.
      }

      return entityRepository.executeQueryX(queryRequest);
    }

    throw Exception('Unable to find repository to handle query request with record of type $R');
  }

  @override
  Future<T> onExecuteQuery<R extends Record, T>(QueryRequest<R, T> queryRequest, {Transaction? transaction}) {
    if (isSubtype<R, Entity>()) {
      final entityRepository = getRepositoryRuntime(R);
      queryRequest = modifiedWithoutCacheIfNeeded(queryRequest);

      if (queryRequest.isWithoutCache()) {
        logMessage('Using without-cache query [$queryRequest]');
      }

      return entityRepository.executeQuery(queryRequest, transaction: transaction);
    }

    throw Exception('Unable to find repository to handle query request with record of type $R');
  }
}
