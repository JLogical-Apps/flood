import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/local_query_executor.dart';

mixin WithLocalEntityRepository<E extends Entity> on EntityRepository<E> {
  Map<String, State> _stateById = Map();

  Map<String, State>? _precommitState;
  Transaction? _currentTransaction;

  @override
  Future<E?> save(E entity, {required Transaction transaction}) async {
    final id = entity.id ?? (throw Exception('Cannot save entity that has a null id!'));
    _stateById[id] = entity.state;
  }

  @override
  Future<E?> getOrNull(String id, {required Transaction transaction}) async {
    return _stateById[id].mapIfNonNull((state) => Entity.fromStateOrNull<E>(state));
  }

  @override
  Future<void> delete(String id, {required Transaction transaction}) async {
    _stateById.remove(id);
  }

  @override
  Future<T> executeQuery<R extends Record, T>(AbstractQueryRequest<R, T> queryRequest) async {
    return LocalQueryExecutor(stateById: _stateById).executeQuery(queryRequest);
  }

  @override
  Future<void> commit() async {
    _currentTransaction.mapIfNonNull((currentTransaction) => unlock(currentTransaction));

    _currentTransaction = null;
    _precommitState = null;
  }

  @override
  Future<void> revert() async {
    final precommitState = _precommitState ?? (throw Exception('Can only revert if a transaction has started!'));
    _stateById = precommitState;

    await commit();
  }
}
