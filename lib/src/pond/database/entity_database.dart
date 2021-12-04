import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';
import 'package:jlogical_utils/src/utils/utils.dart';

class EntityDatabase implements Database {
  final Map<Type, EntityRepository> _repositoryByType;

  EntityDatabase({List<EntityRepository> repositories: const []})
      : _repositoryByType = repositories.map((repository) => MapEntry(repository.entityType, repository)).toMap();

  @override
  EntityRepository getRepositoryRuntimeOrNull(Type entityType) {
    return _repositoryByType[entityType] ?? (throw Exception('Could not find repository for entity $entityType'));
  }

  @override
  Future<T> executeQuery<R extends Record, T>(AbstractQueryRequest<R, T> queryRequest, {Transaction? transaction}) {
    if (isSubtype<R, Entity>()) {
      final entityRepository = getRepositoryRuntime(R);
      return entityRepository.executeQuery(queryRequest, transaction: transaction);
    }

    throw Exception('Unable to find repository to handle query request with record of type $R');
  }
}
