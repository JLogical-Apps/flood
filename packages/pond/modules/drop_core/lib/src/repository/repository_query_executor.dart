import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';

abstract class RepositoryQueryExecutor {
  Future<T> execute<E extends Entity, T>(QueryRequest<E, T> queryRequest);

  Stream<T> executeX<E extends Entity, T>(QueryRequest<E, T> queryRequest);
}

abstract class RepositoryQueryExecutorWrapper implements RepositoryQueryExecutor {
  RepositoryQueryExecutor get queryExecutor;
}

mixin IsRepositoryQueryExecutorWrapper implements RepositoryQueryExecutorWrapper {
  @override
  Future<T> execute<E extends Entity, T>(QueryRequest<E, T> queryRequest) => queryExecutor.execute(queryRequest);

  @override
  Stream<T> executeX<E extends Entity, T>(QueryRequest<E, T> queryRequest) => queryExecutor.executeX(queryRequest);
}
