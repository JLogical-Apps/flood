import 'dart:async';

import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

abstract class RepositoryQueryExecutor {
  Future<T> onExecuteQuery<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  });

  ValueStream<FutureValue<T>> onExecuteQueryX<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  });
}

extension RepositoryQueryExecutorExtensions on RepositoryQueryExecutor {
  Future<List<State>> getFetchedStates(QueryRequest queryRequest) async {
    final states = <State>[];
    await executeQuery(queryRequest, onStateRetreived: (state) => states.add(state));
    return states;
  }

  Future<T> executeQuery<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  }) {
    return onExecuteQuery(queryRequest, onStateRetreived: onStateRetreived);
  }

  ValueStream<FutureValue<T>> executeQueryX<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  }) {
    return onExecuteQueryX(queryRequest, onStateRetreived: onStateRetreived);
  }
}

mixin IsRepositoryQueryExecutor implements RepositoryQueryExecutor {}

abstract class RepositoryQueryExecutorWrapper implements RepositoryQueryExecutor {
  RepositoryQueryExecutor get queryExecutor;
}

mixin IsRepositoryQueryExecutorWrapper implements RepositoryQueryExecutorWrapper {
  @override
  Future<T> onExecuteQuery<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  }) =>
      queryExecutor.onExecuteQuery(queryRequest, onStateRetreived: onStateRetreived);

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  }) =>
      queryExecutor.onExecuteQueryX(queryRequest, onStateRetreived: onStateRetreived);
}
