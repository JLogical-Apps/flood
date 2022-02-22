import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:rxdart/rxdart.dart';

mixin WithDatabaseDelegator implements Database {
  Database get database;

  EntityRepository? getRepositoryRuntimeOrNull(Type entityType) {
    return database.getRepositoryRuntimeOrNull(entityType);
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    return database.executeQueryX<R, T>(queryRequest);
  }

  @override
  Future<T> onExecuteQuery<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    return database.executeQuery<R, T>(queryRequest);
  }
}
