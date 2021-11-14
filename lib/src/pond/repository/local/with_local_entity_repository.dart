import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/local_query_executor.dart';

mixin WithLocalEntityRepository<E extends Entity> on EntityRepository<E> {
  Map<String, E> _entityById = Map();

  @override
  Future<E?> save(E entity) async {
    final id = entity.id ?? (throw Exception('Cannot save entity that has a null id!'));
    _entityById[id] = entity;
  }

  @override
  Future<E?> getOrNull(String id) async {
    return _entityById[id];
  }

  @override
  Future<void> delete(String id) async {
    _entityById.remove(id);
  }

  @override
  Future<T> executeQuery<R extends Record, T>(QueryRequest<R, T> queryRequest) async {
    return LocalQueryExecutor(recordById: _entityById).executeQuery(queryRequest);
  }
}
