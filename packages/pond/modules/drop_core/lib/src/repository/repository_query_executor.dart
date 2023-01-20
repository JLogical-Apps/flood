import 'package:drop_core/src/query/request/query_request.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

abstract class RepositoryQueryExecutor {
  Future<T> execute<T>(QueryRequest<T> queryRequest);

  ValueStream<FutureValue<T>> executeX<T>(QueryRequest<T> queryRequest);
}

abstract class RepositoryQueryExecutorWrapper implements RepositoryQueryExecutor {
  RepositoryQueryExecutor get queryExecutor;
}

mixin IsRepositoryQueryExecutorWrapper implements RepositoryQueryExecutorWrapper {
  @override
  Future<T> execute<T>(QueryRequest<T> queryRequest) => queryExecutor.execute(queryRequest);

  @override
  ValueStream<FutureValue<T>> executeX<T>(QueryRequest<T> queryRequest) => queryExecutor.executeX(queryRequest);
}
