import 'package:collection/collection.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/repository_id_generator.dart';
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
  RepositoryIdGenerator get idGenerator => RepositoryIdGenerator.uuid();

  @override
  RepositoryStateHandler get stateHandler => _RepositoryListStateHandler(repositories: repositories);

  @override
  RepositoryQueryExecutor get queryExecutor => _RepositoryListQueryExecutor(repositories: repositories);

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(
          onRegister: (context, component) => repositories.forEach(context.register),
        )
      ];

  @override
  late CorePondContext context;
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
  Future<void> update(State state) {
    return repositories.firstWhereOrNull((repository) => repository.handledTypes.contains(state.type))?.update(state) ??
        (throw Exception('Cannot find repository to handle update for [$state]'));
  }

  @override
  Future<void> delete(State state) {
    return repositories.firstWhereOrNull((repository) => repository.handledTypes.contains(state.type))?.delete(state) ??
        (throw Exception('Cannot find repository to handle delete for [$state]'));
  }
}

class _RepositoryListQueryExecutor implements RepositoryQueryExecutor {
  final List<Repository> repositories;

  _RepositoryListQueryExecutor({required this.repositories});

  @override
  bool handles(QueryRequest queryRequest) {
    return repositories.any((repository) => repository.handlesQuery(queryRequest));
  }

  @override
  Future<T> onExecute<T>(QueryRequest<T> queryRequest) {
    return repositories
            .firstWhereOrNull((repository) => repository.handlesQuery(queryRequest))
            ?.executeQuery(queryRequest) ??
        (throw Exception('Cannot find repository to handle query request [$queryRequest]'));
  }

  @override
  ValueStream<FutureValue<T>> onExecuteX<T>(QueryRequest<T> queryRequest) {
    return repositories
            .firstWhereOrNull((repository) => repository.handlesQuery(queryRequest))
            ?.executeQueryX(queryRequest) ??
        (throw Exception('Cannot find repository to handle query request [$queryRequest]'));
  }
}
