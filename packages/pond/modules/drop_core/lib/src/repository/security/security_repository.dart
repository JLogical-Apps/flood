import 'dart:async';

import 'package:auth_core/auth_core.dart';
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

  @override
  String toString() {
    return 'SecurityRepository[$repository]';
  }
}

class SecurityQueryExecutor with IsRepositoryQueryExecutorWrapper {
  @override
  final RepositoryQueryExecutor queryExecutor;

  final SecurityRepository securityRepository;

  SecurityQueryExecutor({required this.queryExecutor, required this.securityRepository});

  RepositorySecurity get repositorySecurity => securityRepository.repositorySecurity;

  DropCoreComponent get context => securityRepository.context.dropCoreComponent;

  Account? get loggedInAccount => context.getLoggedInAccount();

  Future<bool> passesReadPermission() async {
    if (context.ignoreSecurity) {
      return true;
    }

    return repositorySecurity.read.passes(context, loggedInAccount: loggedInAccount);
  }

  @override
  Future<T> onExecuteQuery<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  }) async {
    if (!await passesReadPermission()) {
      throw Exception('Invalid permissions to read from [$securityRepository]!');
    }

    return await queryExecutor.executeQuery(
      queryRequest,
      onStateRetreived: (state) async {
        if (!await repositorySecurity.read.passesState(context, state: state, loggedInAccount: loggedInAccount)) {
          throw Exception('Invalid permissions to read [${state.id}] from [$securityRepository]!');
        }
        await onStateRetreived?.call(state);
      },
    );
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  }) {
    return queryExecutor.executeQueryX(queryRequest, onStateRetreived: (state) async {
      if (!await repositorySecurity.read.passesState(context, state: state, loggedInAccount: loggedInAccount)) {
        throw Exception('Invalid permissions to read [${state.id}] from [$securityRepository]!');
      }
      await onStateRetreived?.call(state);
    }).asyncMapWithValue(
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

  Account? get loggedInAccount => context.getLoggedInAccount();

  @override
  Future<State> onUpdate(State state) async {
    if (state.isNew) {
      if (!await passesPermission(permission: repositorySecurity.create, state: state)) {
        throw Exception('Invalid permissions to create [$state]!');
      }
    } else {
      if (!await passesPermission(permission: repositorySecurity.update, state: state)) {
        throw Exception('Invalid permissions to update [$state]!');
      }
    }

    return await stateHandler.update(state);
  }

  @override
  Future<State> onDelete(State state) async {
    if (!await passesPermission(permission: repositorySecurity.delete, state: state)) {
      throw Exception('Invalid permissions to delete [$state]!');
    }

    return await stateHandler.delete(state);
  }

  Future<bool> passesPermission({required Permission permission, required State state}) async {
    if (context.ignoreSecurity) {
      return true;
    }

    return permission.passesState(context, state: state, loggedInAccount: loggedInAccount);
  }
}
