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
import 'package:jlogical_utils/src/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class EntityDatabase implements Database {
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
      return entityRepository.executeQueryX(queryRequest);
    }

    throw Exception('Unable to find repository to handle query request with record of type $R');
  }

  @override
  Future<T> onExecuteQuery<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    if (isSubtype<R, Entity>()) {
      final entityRepository = getRepositoryRuntime(R);
      return entityRepository.executeQuery(queryRequest);
    }

    throw Exception('Unable to find repository to handle query request with record of type $R');
  }
}
