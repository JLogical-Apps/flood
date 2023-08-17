import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

abstract class RepositoryQueryExecutor {
  Future<T> onExecuteQuery<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  });

  ValueStream<FutureValue<T>> onExecuteQueryX<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  });
}

extension RepositoryQueryExecutorExtensions on RepositoryQueryExecutor {
  Future<T> executeQuery<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) {
    return onExecuteQuery(queryRequest, onStateRetreived: onStateRetreived);
  }

  ValueStream<FutureValue<T>> executeQueryX<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
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
