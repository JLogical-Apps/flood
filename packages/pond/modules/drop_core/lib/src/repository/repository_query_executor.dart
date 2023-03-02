import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/repository/query_executor/with_handled_types_repository_query_executor.dart';
import 'package:rxdart/rxdart.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

abstract class RepositoryQueryExecutor {
  bool handlesQuery(QueryRequest queryRequest);

  Future<T> onExecuteQuery<T>(QueryRequest<dynamic, T> queryRequest);

  ValueStream<FutureValue<T>> onExecuteQueryX<T>(QueryRequest<dynamic, T> queryRequest);
}

extension RepositoryQueryExecutorExtensions on RepositoryQueryExecutor {
  Future<T> executeQuery<T>(QueryRequest<dynamic, T> queryRequest) {
    if (!handlesQuery(queryRequest)) {
      throw Exception('Unable to handle [$queryRequest]');
    }
    return onExecuteQuery(queryRequest);
  }

  ValueStream<FutureValue<T>> executeQueryX<T>(QueryRequest<dynamic, T> queryRequest) {
    if (!handlesQuery(queryRequest)) {
      throw Exception('Unable to handle [$queryRequest]');
    }
    return onExecuteQueryX(queryRequest);
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

abstract class RepositoryQueryExecutorWrapper implements RepositoryQueryExecutor {
  RepositoryQueryExecutor get queryExecutor;
}

mixin IsRepositoryQueryExecutorWrapper implements RepositoryQueryExecutorWrapper {
  @override
  bool handlesQuery(QueryRequest queryRequest) => queryExecutor.handlesQuery(queryRequest);

  @override
  Future<T> onExecuteQuery<T>(QueryRequest<dynamic, T> queryRequest) => queryExecutor.onExecuteQuery(queryRequest);

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(QueryRequest<dynamic, T> queryRequest) =>
      queryExecutor.onExecuteQueryX(queryRequest);
}
