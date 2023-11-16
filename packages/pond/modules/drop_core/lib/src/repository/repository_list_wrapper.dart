import 'package:collection/collection.dart';
import 'package:drop_core/src/query/from_query.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';
import 'package:drop_core/src/state/persistence/state_persister.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:runtime_type/type.dart';
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
  StatePersister get statePersister => stateHandler.statePersister;

  @override
  Future<T> onExecuteQuery<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) =>
      queryExecutor.onExecuteQuery(queryRequest, onStateRetreived: onStateRetreived);

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) =>
      queryExecutor.onExecuteQueryX(queryRequest, onStateRetreived: onStateRetreived);
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

  @override
  StatePersister get statePersister => throw Exception('Repository list handlers do not have a state persister!');
}

class _RepositoryListQueryExecutor implements RepositoryQueryExecutor {
  final List<Repository> repositories;

  _RepositoryListQueryExecutor({required this.repositories});

  @override
  Future<T> onExecuteQuery<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) {
    return findRepositoryToHandleQuery(queryRequest).executeQuery(
      queryRequest,
      onStateRetreived: onStateRetreived,
    );
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) {
    return findRepositoryToHandleQuery(queryRequest).executeQueryX(
      queryRequest,
      onStateRetreived: onStateRetreived,
    );
  }

  Repository findRepositoryToHandleQuery(QueryRequest queryRequest) {
    final root = queryRequest.query.root;
    final entitySearchType = (root as FromQuery).entityType;
    if (entitySearchType == typeOf<Entity>()) {
      return repositories.first;
    }

    return repositories.firstWhereOrNull((repository) =>
            repository.handledTypes.map((runtimeType) => runtimeType.type).contains(entitySearchType)) ??
        (throw Exception('Cannot find repository to handle query request [$queryRequest]'));
  }
}
