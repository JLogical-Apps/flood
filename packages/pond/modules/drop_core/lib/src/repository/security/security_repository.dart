import 'package:drop_core/drop_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class SecurityRepository with IsRepositoryWrapper {
  @override
  final Repository repository;

  final RepositorySecurity repositorySecurity;

  SecurityRepository({required this.repository, required this.repositorySecurity});

  @override
  RepositoryStateHandler get stateHandler => SecurityStateHandler(
        stateHandler: super.stateHandler,
        securityRepository: this,
      );

  @override
  RepositoryQueryExecutor get queryExecutor => SecurityQueryExecutor(
        queryExecutor: super.queryExecutor,
        securityRepository: this,
      );
}

class SecurityQueryExecutor with IsRepositoryQueryExecutorWrapper {
  @override
  final RepositoryQueryExecutor queryExecutor;

  final SecurityRepository securityRepository;

  SecurityQueryExecutor({required this.queryExecutor, required this.securityRepository});

  RepositorySecurity get repositorySecurity => securityRepository.repositorySecurity;

  String? get authenticatedUserId => securityRepository.context.dropCoreComponent.authenticatedUserX.value;

  @override
  Future<T> onExecuteQuery<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) {
    if (!repositorySecurity.read.passes(authenticatedUserId: authenticatedUserId)) {
      throw Exception('Invalid permissions to read from [$securityRepository]!');
    }

    return queryExecutor.executeQuery(queryRequest, onStateRetreived: onStateRetreived);
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) {
    if (!repositorySecurity.read.passes(authenticatedUserId: authenticatedUserId)) {
      throw Exception('Invalid permissions to read from [$securityRepository]!');
    }

    return queryExecutor.executeQueryX(queryRequest, onStateRetreived: onStateRetreived);
  }
}

class SecurityStateHandler with IsRepositoryStateHandlerWrapper {
  @override
  final RepositoryStateHandler stateHandler;

  final SecurityRepository securityRepository;

  SecurityStateHandler({required this.stateHandler, required this.securityRepository});

  RepositorySecurity get repositorySecurity => securityRepository.repositorySecurity;

  String? get authenticatedUserId => securityRepository.context.dropCoreComponent.authenticatedUserX.value;

  @override
  Future<State> onUpdate(State state) {
    if (state.isNew) {
      print('checking permissions for $authenticatedUserId');
      if (!repositorySecurity.create.passes(authenticatedUserId: authenticatedUserId)) {
        throw Exception('Invalid permissions to create [$state]!');
      }
    } else {
      if (!repositorySecurity.update.passes(authenticatedUserId: authenticatedUserId)) {
        throw Exception('Invalid permissions to update [$state]!');
      }
    }

    return stateHandler.update(state);
  }

  @override
  Future<State> onDelete(State state) {
    if (!repositorySecurity.delete.passes(authenticatedUserId: authenticatedUserId)) {
      throw Exception('Invalid permissions to delete [$state]!');
    }

    return stateHandler.delete(state);
  }
}
