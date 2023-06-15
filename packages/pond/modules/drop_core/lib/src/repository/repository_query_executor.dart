import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/repository/query_executor/with_handled_types_repository_query_executor.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

abstract class RepositoryQueryExecutor {
  bool handlesQuery(QueryRequest queryRequest);

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

  RepositoryQueryExecutor withHandledType(RuntimeType runtimeType) {
    return WithHandledTypesRepositoryQueryExecutor(
      queryExecutor: this,
      handledTypes: [runtimeType],
    );
  }

  RepositoryQueryExecutor withHandledTypes(List<RuntimeType> runtimeTypes) {
    return WithHandledTypesRepositoryQueryExecutor(
      queryExecutor: this,
      handledTypes: runtimeTypes,
    );
  }
}

mixin IsRepositoryQueryExecutor implements RepositoryQueryExecutor {
  @override
  bool handlesQuery(QueryRequest queryRequest) {
    return false;
  }
}

abstract class RepositoryQueryExecutorWrapper implements RepositoryQueryExecutor {
  RepositoryQueryExecutor get queryExecutor;
}

mixin IsRepositoryQueryExecutorWrapper implements RepositoryQueryExecutorWrapper {
  @override
  bool handlesQuery(QueryRequest queryRequest) => queryExecutor.handlesQuery(queryRequest);

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
