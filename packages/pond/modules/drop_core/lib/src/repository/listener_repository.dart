import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class ListenerRepository with IsRepositoryWrapper {
  @override
  final Repository repository;

  final Function(State state)? onStateRetrieved;

  ListenerRepository({required this.repository, this.onStateRetrieved});

  @override
  late final RepositoryQueryExecutor queryExecutor = ListenerRepositoryQueryExecutor(repository: this);
}

class ListenerRepositoryQueryExecutor with IsRepositoryQueryExecutor {
  final ListenerRepository repository;

  ListenerRepositoryQueryExecutor({required this.repository});

  @override
  Future<T> onExecuteQuery<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) async {
    return await repository.repository.executeQuery(
      queryRequest,
      onStateRetreived: (state) {
        onStateRetreived?.call(state);
        repository.onStateRetrieved?.call(state);
      },
    );
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) {
    return repository.repository.executeQueryX(
      queryRequest,
      onStateRetreived: (state) {
        onStateRetreived?.call(state);
        repository.onStateRetrieved?.call(state);
      },
    );
  }
}
