import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';

mixin WithDatabaseDelegator implements Database {
  Database get database;

  EntityRepository? getRepositoryRuntimeOrNull(Type entityType) {
    return database.getRepositoryRuntimeOrNull(entityType);
  }

  @override
  Future<T> executeQuery<R extends Record, T>(AbstractQueryRequest<R, T> queryRequest, {Transaction? transaction}) {
    return database.executeQuery<R, T>(queryRequest, transaction: transaction);
  }
}
