import 'package:collection/collection.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

abstract class RepositoryListWrapper implements Repository {
  List<Repository> get repositories;

  factory RepositoryListWrapper(List<Repository> repositories) =>
      _RepositoryListWrapperImpl(repositories: repositories);
}

mixin IsRepositoryListWrapper implements RepositoryListWrapper {
  @override
  List<RuntimeType> get handledTypes => repositories.expand((repository) => repository.handledTypes).toList();

  @override
  RepositoryStateHandler get stateHandler => _RepositoryListStateHandler(repositories: repositories);

  @override
  RepositoryQueryExecutor get queryExecutor => _RepositoryListQueryExecutor(repositories: repositories);

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(
          onRegister: (context, component) => Future.wait(repositories.map(context.register)),
        ),
        ...repositories.expand((repository) => repository.behaviors).toList(),
      ];

  @override
  late CorePondContext context;

  @override
  Future<State> onUpdate(State state) => stateHandler.onUpdate(state);

  @override
  Future<State> onDelete(State state) => stateHandler.onDelete(state);

  @override
  bool handlesQuery(QueryRequest queryRequest) => queryExecutor.handlesQuery(queryRequest);

  @override
  Future<T> onExecuteQuery<T>(QueryRequest<dynamic, T> queryRequest) => queryExecutor.onExecuteQuery(queryRequest);

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(QueryRequest<dynamic, T> queryRequest) =>
      queryExecutor.onExecuteQueryX(queryRequest);
}

class _RepositoryListWrapperImpl with IsRepositoryListWrapper {
  @override
  final List<Repository> repositories;

  _RepositoryListWrapperImpl({required this.repositories});
}

class _RepositoryListStateHandler implements RepositoryStateHandler {
  final List<Repository> repositories;

  _RepositoryListStateHandler({required this.repositories});

  @override
  Future<State> onUpdate(State state) {
    return repositories.firstWhereOrNull((repository) => repository.handledTypes.contains(state.type))?.update(state) ??
        (throw Exception('Cannot find repository to handle update for [$state]'));
  }

  @override
  Future<State> onDelete(State state) {
    return repositories.firstWhereOrNull((repository) => repository.handledTypes.contains(state.type))?.delete(state) ??
        (throw Exception('Cannot find repository to handle delete for [$state]'));
  }
}

class _RepositoryListQueryExecutor implements RepositoryQueryExecutor {
  final List<Repository> repositories;

  _RepositoryListQueryExecutor({required this.repositories});

  @override
  bool handlesQuery(QueryRequest queryRequest) {
    return repositories.any((repository) => repository.handlesQuery(queryRequest));
  }

  @override
  Future<T> onExecuteQuery<T>(QueryRequest<dynamic, T> queryRequest) {
    return repositories
            .firstWhereOrNull((repository) => repository.handlesQuery(queryRequest))
            ?.executeQuery(queryRequest) ??
        (throw Exception('Cannot find repository to handle query request [$queryRequest]'));
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(QueryRequest<dynamic, T> queryRequest) {
    return repositories
            .firstWhereOrNull((repository) => repository.handlesQuery(queryRequest))
            ?.executeQueryX(queryRequest) ??
        (throw Exception('Cannot find repository to handle query request [$queryRequest]'));
  }
}
