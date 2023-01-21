import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/repository/query_executor/with_handled_types_repository_query_executor.dart';
import 'package:rxdart/rxdart.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

abstract class RepositoryQueryExecutor {
  bool handles(QueryRequest queryRequest);

  Future<T> onExecute<T>(QueryRequest<T> queryRequest);

  ValueStream<FutureValue<T>> onExecuteX<T>(QueryRequest<T> queryRequest);
}

extension RepositoryQueryExecutorExtensions on RepositoryQueryExecutor {
  Future<T> execute<T>(QueryRequest<T> queryRequest) {
    if (!handles(queryRequest)) {
      throw Exception('Unable to handle [$queryRequest]');
    }
    return onExecute(queryRequest);
  }

  ValueStream<FutureValue<T>> executeX<T>(QueryRequest<T> queryRequest) {
    if (!handles(queryRequest)) {
      throw Exception('Unable to handle [$queryRequest]');
    }
    return onExecuteX(queryRequest);
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
  bool handles(QueryRequest queryRequest) => queryExecutor.handles(queryRequest);

  @override
  Future<T> onExecute<T>(QueryRequest<T> queryRequest) => queryExecutor.onExecute(queryRequest);

  @override
  ValueStream<FutureValue<T>> onExecuteX<T>(QueryRequest<T> queryRequest) => queryExecutor.onExecuteX(queryRequest);
}
