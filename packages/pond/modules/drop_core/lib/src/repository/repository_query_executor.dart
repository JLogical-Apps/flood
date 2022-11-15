import 'package:drop_core/src/query/request/query_request.dart';

abstract class RepositoryQueryExecutor {
  Future<T> execute<T>(QueryRequest<T> queryRequest);

  Stream<T> executeX<T>(QueryRequest<T> queryRequest);
}

abstract class RepositoryQueryExecutorWrapper implements RepositoryQueryExecutor {
  RepositoryQueryExecutor get queryExecutor;
}

mixin IsRepositoryQueryExecutorWrapper implements RepositoryQueryExecutorWrapper {
  @override
  Future<T> execute<T>(QueryRequest<T> queryRequest) => queryExecutor.execute(queryRequest);

  @override
  Stream<T> executeX<T>(QueryRequest<T> queryRequest) => queryExecutor.executeX(queryRequest);
}
