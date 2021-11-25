import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';
import 'package:jlogical_utils/src/patterns/resolver/with_resolver_provider.dart';
import 'package:jlogical_utils/src/patterns/resolver/with_typed_resolver.dart';
import 'package:jlogical_utils/src/pond/query/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/utils/collection_extensions.dart';
import 'package:jlogical_utils/src/utils/types.dart';

class Database
    with WithResolverProvider<Entity, EntityRepository>
    implements QueryExecutor, Resolver<Entity, EntityRepository> {
  final List<EntityRepository> repositories;

  @override
  final Resolver<Entity, EntityRepository> resolver;

  Database({required this.repositories}) : resolver = _EntityRepositoryResolver(repositories: repositories);

  EntityRepository<E> getRepository<E extends Entity>() {
    return getRepositoryRuntime(E) as EntityRepository<E>;
  }

  EntityRepository getRepositoryRuntime(Type entityType) {
    return repositories.firstWhereOrNull((repository) => repository.entityType == entityType) ??
        (throw Exception('Cannot find repository for $entityType'));
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

class _EntityRepositoryResolver
    with WithTypedResolver<Entity, EntityRepository>
    implements Resolver<Entity, EntityRepository> {
  final List<EntityRepository> repositories;

  const _EntityRepositoryResolver({required this.repositories});

  @override
  Map<Type, EntityRepository> get outputByType =>
      repositories.map((repository) => MapEntry(repository.entityType, repository)).toMap();
}
