import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/state/state_change.dart';
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

  DropCoreComponent get context => securityRepository.context.dropCoreComponent;

  String? get authenticatedUserId => context.authenticatedUserIdX.value;

  Future<bool> passesReadPermission() async {
    if (context.ignoreSecurity) {
      return true;
    }

    return await repositorySecurity.read.passes(context, authenticatedUserId: authenticatedUserId, stateChange: null);
  }

  @override
  Future<T> onExecuteQuery<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) async {
    if (!await passesReadPermission()) {
      throw Exception('Invalid permissions to read from [$securityRepository]!');
    }

    return await queryExecutor.executeQuery(queryRequest, onStateRetreived: onStateRetreived);
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) {
    return queryExecutor.executeQueryX(queryRequest, onStateRetreived: onStateRetreived).asyncMapWithValue(
      (result) async {
        if (!await passesReadPermission()) {
          throw Exception('Invalid permissions to read from [$securityRepository]!');
        }

        return result;
      },
      initialValue: FutureValue.loading(),
    );
  }
}

class SecurityStateHandler with IsRepositoryStateHandlerWrapper {
  @override
  final RepositoryStateHandler stateHandler;

  final SecurityRepository securityRepository;

  SecurityStateHandler({required this.stateHandler, required this.securityRepository});

  RepositorySecurity get repositorySecurity => securityRepository.repositorySecurity;

  DropCoreComponent get context => securityRepository.context.dropCoreComponent;

  String? get authenticatedUserId => context.authenticatedUserIdX.value;

  @override
  Future<State> onUpdate(State state) async {
    final stateChange = await getStateChange(state);

    if (state.isNew) {
      if (!await passesPermission(repositorySecurity.create, stateChange: stateChange)) {
        throw Exception('Invalid permissions to create [$state]!');
      }
    } else {
      if (!await passesPermission(repositorySecurity.update, stateChange: stateChange)) {
        throw Exception('Invalid permissions to update [$state]!');
      }
    }

    return await stateHandler.update(state);
  }

  @override
  Future<State> onDelete(State state) async {
    if (!await passesPermission(repositorySecurity.delete)) {
      throw Exception('Invalid permissions to delete [$state]!');
    }

    return await stateHandler.delete(state);
  }

  Future<bool> passesPermission(Permission permission, {StateChange? stateChange}) async {
    if (context.ignoreSecurity) {
      return true;
    }

    return await permission.passes(context, authenticatedUserId: authenticatedUserId, stateChange: stateChange);
  }

  Future<StateChange> getStateChange(State state) async {
    if (state.id == null) {
      return StateChange(oldState: null, newState: state);
    }

    final oldEntity = await securityRepository.executeQuery(Query.getByIdOrNullRuntime(state.type!.type, state.id!));
    final oldState = oldEntity?.value.getState(context);
    return StateChange(oldState: oldState, newState: state);
  }
}
